# frozen_string_literal: true

class ParticipationsController < ApplicationController
  skip_before_action :authenticate
  invisible_captcha only: :create, honeypot: :subtitle

  def new
    @participation = Participation.new
  end

  def create
    @participation = Participation.new(permitted_params)

    return if @participation.save

    render :new, status: :unprocessable_entity
  end

  private

  def permitted_params
    params.require(:participation).permit(:authority_name, :authority_address, :authority_email, :contact_name,
                                          :contact_email, :contact_phone, :privacy_policy_accepted)
  end
end
