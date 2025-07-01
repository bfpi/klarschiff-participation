# frozen_string_literal: true

class ResignationMailer < ApplicationMailer
  def informed_resignation(participation)
    generate_activity_token(participation)
    @resignation_confirm = resignation_confirm_url(activity_token: participation.activity_token)
    @resignation_reject = resignation_reject_url(activity_token: participation.activity_token)
    @participation = participation
    mail(to: participation.contact_email, subject: default_i18n_subject)
  end

  def provide_resignation(participation)
    generate_activity_token(participation)
    @resignation_new = resignation_new_url(activity_token: participation.activity_token)
    @participation = participation
    mail(to: participation.official_email_authority, subject: default_i18n_subject)
  end

  def resigned(participation)
    @participation = participation
    mail(to: participation.official_email_authority, subject: default_i18n_subject)
  end
end
