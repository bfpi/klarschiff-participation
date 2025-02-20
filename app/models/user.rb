# frozen_string_literal: true

class User < ApplicationRecord
  include Logging

  enum :role, { admin: 0, editor: 1 }, prefix: true

  validates :name, :login, presence: true, uniqueness: true

  scope :active, -> { where(active: true) }

  has_secure_password validations: false
  self.omit_field_log_values += %w[password_digest password_history]

  def to_s
    login
  end
end
