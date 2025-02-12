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
    return Current.user.present? if role.blank?
    return Current.user.role_admin? if role == :admin

    false
  end
end
