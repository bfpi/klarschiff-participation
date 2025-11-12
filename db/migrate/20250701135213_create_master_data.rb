# frozen_string_literal: true

class CreateMasterData < ActiveRecord::Migration[8.0]
  def change
    create_table :master_data do |t|
      t.string :leading_cooperation_partner_name
      t.string :leading_cooperation_partner_address
      t.string :leading_cooperation_partner_email

      t.timestamps
    end
  end
end
