# frozen_string_literal: true

module Authorization
  extend ActiveSupport::Concern

  included do
    helper_method :authorized?
  end

  private

  def check_authorization(role = nil)
    return if authorized?(role)

    render template: 'application/denied', status: :forbidden
  end

  def authorized?(role)
    case role
    when nil
      Current.user.present?
    when :admin
      Current.user.role_admin?
    else
      Rails.logger.error "Unknown role '#{role}' for authorization requested!"
      false
    end
  end
end
