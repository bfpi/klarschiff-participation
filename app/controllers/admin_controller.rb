# frozen_string_literal: true

class AdminController < ApplicationController
  before_action :authenticate

  include Authorization

  def return_new_with_flash(status:, flash_type: :alert, message_key: nil, message: nil)
    flash.now[flash_type] = t(message_key) if message_key
    flash.now[flash_type] = message if message
    render :new, status: status
  end

  private

  def authenticate
    if (Current.user = User.active.find_by(User.arel_table[:login].matches(session[:login]))).present?
      logger.info "Username: #{Current.user&.login}"
    else
      redirect_to new_admin_logins_path
    end
  end
end
