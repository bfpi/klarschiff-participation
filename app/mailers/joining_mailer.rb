# frozen_string_literal: true

class JoiningMailer < ApplicationMailer
  def informed(participation)
    generate_activity_token(participation)
    @joining_confirm = joining_confirm_url(activity_token: participation.activity_token)
    @joining_reject = joining_reject_url(activity_token: participation.activity_token)
    @participation = participation
    mail(to: participation.contact_email, subject: default_i18n_subject)
  end

  def provide(participation)
    generate_activity_token(participation)
    @joining_new = joining_new_url(activity_token: participation.activity_token)
    @participation = participation
    mail(to: participation.official_email_authority, subject: default_i18n_subject)
  end
end
