# frozen_string_literal: true

class LoginsController < ApplicationController
  skip_before_action :authenticate

  def new; end

  # rubocop:disable Metrics/AbcSize
  def create
    user = Config.for(:users)[:user].select { |k, _v| k == login_params[:login] }
    unless (@last_login = user&.values&.first == Digest::MD5.hexdigest(login_params[:password]))
      @error = 'Login oder Passwort sind nicht korrekt'
      logger.info "#{@error} (Login: '#{login_params[:login]}')"
      return render :new
    end
    session[:login] = user.keys.first
    redirect_to admin_participations_url
  end
  # rubocop:enable Metrics/AbcSize

  def destroy
    session[:login] = nil
    redirect_to new_logins_url
  end

  def login_params
    params.require(:login).permit(:login, :password)
  end
end
