# frozen_string_literal: true

class LogEntry < ApplicationRecord
  belongs_to :user, optional: true
end
