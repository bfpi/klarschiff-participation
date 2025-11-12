# frozen_string_literal: true

class MasterData < ApplicationRecord
  include Logging

  validates :leading_cooperation_partner_name, :leading_cooperation_partner_address,
            :leading_cooperation_partner_email, presence: true
end
