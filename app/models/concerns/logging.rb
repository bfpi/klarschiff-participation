# frozen_string_literal: true

module Logging
  extend ActiveSupport::Concern

  module ClassMethods
    attr_accessor :omit_field_log, :omit_field_log_values
  end

  included do
    self.omit_field_log = %w[updated_at]
    self.omit_field_log_values = []

    after_create :log_create
    before_update :log_update
    after_destroy :log_destroy

    has_many :log_entries, ->(c) { where(table: c.class.table_name) }, # rubocop:disable Rails/InverseOf, Rails/HasManyOrHasOneDependent
             foreign_key: :subject_id do
      def generate(attr, _action_key, old_value, new_value, old_id: nil, new_id: nil)
        subject = proxy_association.owner
        old, new = converted_changes(attr, subject, old_value, new_value)
        return if old.blank? && new.blank?

        create table: subject.model_name.element, attr:,
               subject_id: subject.id, subject_name: subject.logging_subject_name,
               action: Logging.generate_action(subject.class, attr, :update, old, new),
               user: Current.user,
               old_value: old, new_value: new, old_value_id: old_id, new_value_id: new_id
      end

      private

      def converted_changes(attr, subject, old_value, new_value)
        [Logging.convert_value(old_value, attr, subject), Logging.convert_value(new_value, attr, subject)]
      end
    end
  end

  def log_create
    log_entries.create table: model_name.element, action: Logging.action_text(:create), user: Current.user,
                       subject_id: id, subject_name: logging_subject_name
  end

  def log_update
    changes.each_key do |attr|
      next if attr.in?(self.class.omit_field_log || self.class.superclass.omit_field_log)

      (old, new) = changes[attr]
      if ((k, v) = find_reflection_for_attr(attr))
        log_update_for_reflection(k, v, old, new)
      else
        log_update_for_non_reflection(attr, old, new)
      end
    end
  end

  def find_reflection_for_attr(attr)
    self.class.reflections.find { |r| r.last.foreign_key == attr }
  end

  def log_update_for_reflection(attr, reflection, old, new)
    klass = reflection.klass
    log_entries.generate attr, :update, klass.find_by(id: old).to_s, klass.find_by(id: new).to_s,
                         old_id: old, new_id: new
  end

  def log_update_for_non_reflection(attr, old, new)
    old = new = nil if attr.in?(self.class.omit_field_log_values || self.class.superclass.omit_field_log_values)
    log_entries.generate attr, :update, old, new
  end

  def log_destroy
    LogEntry.create table: model_name.element, action: Logging.action_text(:removed), user: Current.user,
                    subject_id: id, subject_name: logging_subject_name
  end

  def log_habtm_add(obj)
    log_assoc "#{obj.logging_subject_name} #{Logging.action_text :added}"
  end

  def log_habtm_remove(obj)
    log_assoc "#{obj.logging_subject_name} #{Logging.action_text :removed}"
  end

  def log_assoc(action)
    return unless id

    log_entries.create table: model_name.element, action:, user: Current.user,
                       subject_id: id, subject_name: logging_subject_name
  end

  def logging_subject_name
    "#{model_name.human} #{self}"
  end

  def self.generate_action(subject_class, attr, action_key, old_value, new_value)
    text = "#{subject_class.human_attribute_name(attr)} #{Logging.action_text(action_key)}"
    text += ": '#{old_value}' →  '#{new_value}'" unless old_value.nil? && new_value.nil?
    text
  end

  def self.action_text(key)
    case key
    when :update then 'geändert'
    when :create then 'angelegt'
    when :added then 'hinzugefügt'
    when :removed then 'entfernt'
    else raise "Unknown action_key #{key}"
    end
  end

  def self.convert_value(value, attr, subject)
    return subject.class.human_enum_name(attr, value) if attr.in?(subject.defined_enums.keys)
    return ActiveSupport::NumberHelper.number_to_delimited(value) if value.is_a?(Numeric)
    return I18n.l(value) if value.is_a?(Date) || value.is_a?(ActiveSupport::TimeWithZone)

    case value
    when false, true then I18n.t(value)
    else value
    end
  end
end
