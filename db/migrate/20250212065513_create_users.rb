# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.boolean :active, null: false, default: false
      t.text 'name'
      t.text 'login'
      t.text 'password_digest'
      t.integer 'role'

      t.timestamps
    end

    add_index :users, :name, unique: true
    add_index :users, :login, unique: true
  end
end
