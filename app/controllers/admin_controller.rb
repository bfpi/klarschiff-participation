# frozen_string_literal: true

class AdminController < ApplicationController
  include Authorization

  before_action :authenticate

  private

  def return_new_with_flash(status:, flash_type: :alert, message_key: nil, message: nil)
    flash.now[flash_type] = t(message_key) if message_key
    flash.now[flash_type] = message if message
    render :new, status: status
  end

  def authenticate
    if (Current.user = User.active.find_by(User.arel_table[:login].matches(session[:login]))).present?
      logger.info "Username: #{Current.user.login}"
    else
      redirect_to new_admin_logins_path
    end
  end
end
