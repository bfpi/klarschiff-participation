# frozen_string_literal: true

module Admin
  class LoginsController < AdminController
    skip_before_action :authenticate

    def new; end

    def create
      if permitted_params.values.any?(&:blank?)
        return return_new_with_flash(message_key: '.empty_parameter', status: :unauthorized)
      end

      login
      return return_new_with_flash(message_key: '.login_incorrect', status: :unauthorized) if Current.user.blank?

      redirect_to admin_root_path
    end

    def destroy
      session[:login] = nil
      redirect_to new_admin_logins_path
    end

    private

    def login
      user = User.find_by(User.arel_table[:login].matches(permitted_params[:login]))
      return unless user&.authenticate(permitted_params[:password])

      session[:login] = user.login
      Current.user = user
    end

    def permitted_params
      params.expect(login: %i[login password])
    end
  end
end
