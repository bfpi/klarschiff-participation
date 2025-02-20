# frozen_string_literal: true

class ApplicationController < ActionController::Base
  private

  def page
    params[:page] || 1
  end

  def per_page
    params[:per_page] || 20
  end
end
