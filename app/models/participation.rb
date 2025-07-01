# frozen_string_literal: true

class Participation < ApplicationRecord
  include Logging

  default_scope { where(active: true) }

  enum :role, { procedural_responsibility: 0, office: 1, coordination: 2, steering_committee: 3, product_owner: 4 },
       prefix: true
  enum :status, { interested: 0, prepared: 1, informed: 2, call_back: 3, provide: 4, joining: 5, joined: 6,
                  informed_resignation: 7, provide_resignation: 8, resignedly: 9, resignedly_check: 10,
                  resigned: 11 }, prefix: true
  enum :ra_training, { invited: 0, joined: 1, repeated_invitation: 2, without_reply: 3 },
       prefix: true

  attr_accessor :place_of_signature, :privacy_policy_accepted

  validates :privacy_policy_accepted, acceptance: true
  validates :authority_name, :authority_address, :authority_email, :contact_name, :contact_email, :contact_phone,
            :status, presence: true
  validates :authority_email, :contact_email, email: { mode: :strict }
  validates :effectiveness_date, :withdrawal_receipt_date, :withdrawal_effectiveness_date,
            :withdrawal_effectiveness_date_corrected, timeliness: { type: :date }, allow_blank: true

  validates :place_of_signature, :withdrawal_name_of_the_signatory, presence: true, if: lambda {
    status_changed? && (status_joining? || status_resignedly?)
  }
end
