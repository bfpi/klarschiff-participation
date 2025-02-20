# frozen_string_literal: true

require 'test_helper'

class ParticipationsControllerControllerTest < ActionDispatch::IntegrationTest
  test 'index for participations list' do
    get '/participations'

    assert_response :success
  end
end
