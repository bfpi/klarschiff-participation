# frozen_string_literal: true

class Participation < ApplicationRecord
  paginates_per 15

  attr_accessor :privacy_policy_accepted

  validates :privacy_policy_accepted, acceptance: true
  validates :authority_name, :authority_address, :authority_email, :contact_name, :contact_email, :contact_phone,
            presence: true
  validates :authority_email, :contact_email, email: { mode: :strict }
end
