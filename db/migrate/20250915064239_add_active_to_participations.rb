# frozen_string_literal: true

class AddActiveToParticipations < ActiveRecord::Migration[7.1]
  def change
    change_table :participations, bulk: true do |t|
      t.boolean :active, default: true, null: false
    end
  end
end
