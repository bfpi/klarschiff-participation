# frozen_string_literal: true

class JoiningController < ApplicationController
  def confirm
    participation = Participation.status_informed.find_by(activity_token: params[:activity_token])
    return render template: 'application/confirmation_error', status: :not_found if participation.blank?

    participation.status_provide!
  end

  def reject
    participation = Participation.status_informed.find_by(activity_token: params[:activity_token])
    return render template: 'application/confirmation_error', status: :not_found if participation.blank?

    participation.status_call_back!
  end

  def new
    @participation = Participation.status_provide.find_by(activity_token: params[:activity_token])
    render template: 'application/confirmation_error', status: :not_found if @participation.blank?
  end

  def create
    @participation = Participation.status_provide.find_by(params.expect(participation: %i[activity_token]))
    return render template: 'application/confirmation_error', status: :not_found if @participation.blank?

    @participation.update(params.expect(participation: %i[place_of_signature
                                                          name_of_the_signatory]).merge(status: :joining))
    render template: 'joining/new' unless @participation.save
    redirect_to mailto_response, allow_other_host: true
  end

  private

  def mailto_response
    to = MasterData.first.leading_cooperation_partner_email
    subject = t('.subject')
    str = render_to_string(template: 'joining/create_mail', formats: :text)
    "mailto:?to=#{format(to)}&subject=#{format(subject)}&body=#{ERB::Util.url_encode(str)}"
  end
end
