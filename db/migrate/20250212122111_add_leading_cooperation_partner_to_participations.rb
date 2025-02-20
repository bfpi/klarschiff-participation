# frozen_string_literal: true

class AddLeadingCooperationPartnerToParticipations < ActiveRecord::Migration[7.1]
  def change
    change_table :participations, bulk: true do |t|
      t.string :leading_cooperation_partner_name
      t.string :leading_cooperation_partner_address
      t.string :leading_cooperation_partner_email
    end
  end
end
