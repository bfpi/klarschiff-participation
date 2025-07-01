# frozen_string_literal: true

class AddActivityTokenToParticipations < ActiveRecord::Migration[8.0]
  def change
    add_column :participations, :activity_token, :uuid
  end
end
