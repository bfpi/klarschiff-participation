# frozen_string_literal: true

module Admin
  class LoginsController < AdminController
    skip_before_action :authenticate

    def new; end

    def create
      if permitted_params.values.any?(&:blank?)
        return return_new_with_flash(message_key: '.empty_parameter', status: :bad_request)
      end

      login
      return return_new_with_flash(message_key: '.login_incorrect', status: :bad_request) if Current.user.blank?

      redirect_to admin_root_path
    end

    def destroy
      session[:login] = nil
      redirect_to new_admin_logins_path
    end

    private

    def login
      user = user(permitted_params[:login])
      return unless user&.authenticate(permitted_params[:password])

      session[:login] = user.login
      Current.user = user
    end

    def user(login)
      User.where(User.arel_table[:login].matches(login)).first
    end

    def permitted_params
      params.require(:login).permit(:login, :password)
    end
  end
end
