# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'from@example.com'
  layout 'mailer'

  private

  def generate_activity_token(participation)
    participation.update activity_token: SecureRandom.uuid
  end
end
