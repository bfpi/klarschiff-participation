# frozen_string_literal: true

class AddAdditionalsToParticipations < ActiveRecord::Migration[7.1]
  def change
    change_table :participations, bulk: true do |t|
      t.integer 'status', default: 0
      t.string :partner_number
      t.string :name_of_the_signatory
      t.string :official_email_authority
      t.integer :role
      t.date :effectiveness_date
      t.date :withdrawal_receipt_date
      t.string :withdrawal_name_of_the_signatory
      t.date :withdrawal_effectiveness_date
      t.date :withdrawal_effectiveness_date_corrected
    end
  end
end
