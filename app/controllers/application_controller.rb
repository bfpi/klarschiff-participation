# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate

  def authenticate
    if Config.for(:users)[:user].key?(session[:login])
      Current.user = session[:login]
      logger.info "Username: #{Current.user}"
    else
      redirect_to new_admin_logins_url
    end
  end
end
