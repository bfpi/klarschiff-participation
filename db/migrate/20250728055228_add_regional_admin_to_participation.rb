# frozen_string_literal: true

class AddRegionalAdminToParticipation < ActiveRecord::Migration[8.0]
  def change
    change_table :participations, bulk: true do |t|
      t.string :ra_name
      t.string :ra_email
      t.string :ra_phone
      t.text :ra_note
      t.boolean :ra_active, null: false, default: false
      t.date :ra_activate_date
      t.boolean :ra_trained, null: false, default: false
      t.date :ra_train_date
      t.integer :ra_training
    end
  end
end
