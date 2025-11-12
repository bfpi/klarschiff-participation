# frozen_string_literal: true

class Participation < ApplicationRecord
  include Logging

  default_scope { where(active: true) }

  enum :role, { procedural_responsibility: 0, office: 1, coordination: 2, steering_committee: 3, product_owner: 4 },
       prefix: true
  enum :status, { interested: 0, prepared: 1, informed: 2, call_back: 3, provide: 4, joining: 5, joined: 6,
                  informed_withdrawal: 7, provide_withdrawal: 8, withdrawal: 9, withdrawal_check: 10,
                  withdraw: 11 }, prefix: true
  enum :ra_training, { invited: 0, joined: 1, repeated_invitation: 2, without_reply: 3 },
       prefix: true

  attr_accessor :place_of_signature, :privacy_policy_accepted

  validates :privacy_policy_accepted, acceptance: true
  validates :authority_name, :authority_address, :authority_email, :contact_name, :contact_email, :contact_phone,
            :status, presence: true
  validates :authority_email, email: { mode: :strict }, if: -> { authority_email.present? }
  validates :contact_email, email: { mode: :strict }, if: -> { contact_email.present? }
  validates :effectiveness_date, :withdrawal_receipt_date, :withdrawal_effectiveness_date,
            :withdrawal_effectiveness_date_corrected, timeliness: { type: :date }, allow_blank: true

  validates :place_of_signature, :name_of_the_signatory, presence: true, if: -> { status_changed? && status_joining? }
  validates :place_of_signature, :withdrawal_name_of_the_signatory, presence: true, if: lambda {
    status_changed? && status_withdrawal?
  }

  validates :official_email_authority, email: { mode: :strict }, if: -> { official_email_authority.present? }

  before_save :update_official_email_authority, if: lambda {
    status_interested? && official_email_authority_change.present?
  }
  before_save :changed_to_status_informed, if: -> { !activity_token_changed? && status_changed? && status_informed? }
  before_save :changed_to_status_provide, if: -> { !activity_token_changed? && status_changed? && status_provide? }
  before_save :changed_to_status_joining, if: -> { status_changed? && status_joining? }
  before_save :changed_to_status_informed_withdrawal, if: lambda {
    !activity_token_changed? && status_changed? && status_informed_withdrawal?
  }
  before_save :changed_to_status_provide_withdrawal, if: lambda {
    !activity_token_changed? && status_changed? && status_provide_withdrawal?
  }
  validates :withdrawal_effectiveness_date, presence: true, if: -> { status_changed? && status_withdrawal? }
  before_save :changed_to_status_withdrawal_check, if: -> { status_changed? && status_withdrawal_check? }
  before_save :changed_to_status_withdraw, if: -> { !activity_token_changed? && status_changed? && status_withdraw? }

  def at_least_prepared?
    status_index >= Participation.statuses[:prepared]
  end

  def at_least_informed_withdrawal?
    status_index >= Participation.statuses[:informed_withdrawal]
  end

  private

  def status_index
    self.class.statuses[status]
  end

  def update_official_email_authority
    return if official_email_authority.blank?

    status_prepared! if official_email_authority.present?
  end

  def changed_to_status_informed
    JoiningMailer.informed(self).deliver_now
  end

  def changed_to_status_provide
    JoiningMailer.provide(self).deliver_now
  end

  def changed_to_status_joining
    self.effectiveness_date = Time.zone.today.next_month.beginning_of_month
  end

  def changed_to_status_informed_withdrawal
    WithdrawalMailer.informed_withdrawal(self).deliver_now
  end

  def changed_to_status_provide_withdrawal
    WithdrawalMailer.provide_withdrawal(self).deliver_now
  end

  def changed_to_status_withdrawal_check
    self.withdrawal_receipt_date = Time.zone.today
  end

  def changed_to_status_withdraw
    WithdrawalMailer.withdraw(self).deliver_now
  end
end
