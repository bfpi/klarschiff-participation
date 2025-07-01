# frozen_string_literal: true

class RemoveLeadingCooperationPartnerFromParticipations < ActiveRecord::Migration[8.0]
  def change
    change_table :participations, bulk: true do |t|
      t.remove :leading_cooperation_partner_name, type: :string
      t.remove :leading_cooperation_partner_address, type: :string
      t.remove :leading_cooperation_partner_email, type: :string
    end
  end
end
