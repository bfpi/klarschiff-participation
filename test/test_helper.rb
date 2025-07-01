# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
    setup do
      Current.user = nil
      ActionMailer::Base.deliveries.clear
    end

    def login(username: :one, password: 'testpassword')
      assert user(username)
      post admin_logins_url, params: { login: { login: username, password: password } }

      assert_equal username.to_s, session[:login]
    end
  end
end
