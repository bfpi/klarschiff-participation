# frozen_string_literal: true

class CreateParticipation < ActiveRecord::Migration[7.0]
  def change
    create_table :participations do |t|
      t.string :authority_name
      t.string :authority_address
      t.string :authority_email
      t.string :contact_name
      t.string :contact_email
      t.string :contact_phone

      t.timestamps
    end
  end
end
