# frozen_string_literal: true

require 'test_helper'

class ParticipationsControllerControllerTest < ActionDispatch::IntegrationTest
  test 'authorized index for admin' do
    get '/participations'

    assert_response :success
  end
end
