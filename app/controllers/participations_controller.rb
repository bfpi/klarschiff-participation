# frozen_string_literal: true

class ParticipationsController < ApplicationController
  invisible_captcha only: :create, honeypot: :subtitle

  def index
    @participations = Participation.order(created_at: :desc).page(page).per(per_page)
  end

  def new
    @participation = Participation.new
  end

  def create
    @participation = Participation.new({ status: :interested }.merge(permitted_params))

    return if @participation.save

    render :new, status: :unprocessable_entity
  end

  private

  def permitted_params
    params.expect(participation: %i[authority_name authority_address authority_email contact_name
                                    contact_email contact_phone privacy_policy_accepted])
  end
end
