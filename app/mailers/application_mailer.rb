# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: Settings::Mailer.from

  layout 'mailer'

  private

  def generate_activity_token(participation)
    participation.update activity_token: SecureRandom.uuid
  end
end
