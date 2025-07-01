# frozen_string_literal: true

class WithdrawalMailer < ApplicationMailer
  def informed_withdrawal(participation)
    generate_activity_token(participation)
    @participation = participation
    mail(to: participation.contact_email, subject: default_i18n_subject)
  end

  def provide_withdrawal(participation)
    generate_activity_token(participation)
    @participation = participation
    mail(to: participation.official_email_authority, subject: default_i18n_subject)
  end

  def withdraw(participation)
    @participation = participation
    mail(to: participation.official_email_authority, subject: default_i18n_subject)
  end
end
