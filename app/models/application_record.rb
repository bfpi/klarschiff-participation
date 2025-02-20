# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  def self.human_enum_name(enum_name, value)
    I18n.t "enums.#{model_name.i18n_key}.#{enum_name}.#{value}",
           default: I18n.t("enums.#{enum_name}.#{value}", default: '')
  end

  def to_s
    "##{id}"
  end

  def human_enum_name(enum_name)
    self.class.human_enum_name enum_name, self[enum_name]
  end
end
