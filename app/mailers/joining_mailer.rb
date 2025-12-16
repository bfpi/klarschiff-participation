# frozen_string_literal: true

class JoiningMailer < ApplicationMailer
  def informed(participation)
    generate_activity_token(participation)
    @participation = participation
    mail(to: participation.contact_email, subject: default_i18n_subject)
  end

  def provide(participation)
    generate_activity_token(participation)
    @participation = participation
    mail(to: participation.official_email_authority, subject: default_i18n_subject)
  end

  def joining(participation)
    @participation = participation
    mail(to: MasterData.first.leading_cooperation_partner_email, subject: t('joining.new.title_copy'))
  end
end
