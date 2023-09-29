# frozen_string_literal: true

module Admin
  class ParticipationsController < ApplicationController
    def index
      @participations = Participation.order(created_at: :desc)
    end
  end
end
