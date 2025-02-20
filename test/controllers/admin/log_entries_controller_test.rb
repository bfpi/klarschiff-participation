# frozen_string_literal: true

require 'test_helper'

module Admin
  class LogEntriesControllerTest < ActionDispatch::IntegrationTest
    test 'authorized index as admin' do
      login username: 'admin'
      get '/admin/log_entries'

      assert_response :success
    end

    test 'not authorized index as editor' do
      login username: 'editor'
      get '/admin/log_entries'

      assert_response :forbidden
    end
  end
end
