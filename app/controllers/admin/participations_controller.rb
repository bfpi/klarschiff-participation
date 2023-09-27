# frozen_string_literal: true

module Admin
  class ParticipationsController < ApplicationController
    def index
      @participations = Participation.order(created_at: :desc).page(params[:page])
    end

    def show
      @participation = Participation.find(params[:id])
    end
  end
end
