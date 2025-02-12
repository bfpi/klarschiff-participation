# frozen_string_literal: true

class CreateLogEntry < ActiveRecord::Migration[7.1]
  def change
    create_table :log_entries do |t|
      t.text :table
      t.text :attr
      t.bigint :subject_id
      t.text :subject_name
      t.text :action
      t.text :user
      t.text :old_value
      t.text :new_value
      t.bigint :old_value_id
      t.bigint :new_value_id, index: true

      t.references :user, foreign_key: true
      t.timestamps

      t.index %i[table subject_id]
    end
  end
end
