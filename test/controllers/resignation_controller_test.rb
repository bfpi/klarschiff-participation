# frozen_string_literal: true

require 'test_helper'

class ResignationControllerTest < ActionDispatch::IntegrationTest
  test 'confirm for resignation' do
    get "/resignation/#{participation(:informed_resignation).activity_token}/confirm"

    assert_response :success
    assert_predicate participation(:informed_resignation).reload, :status_provide_resignation?
  end

  test 'invalid token confirm for resignation' do
    get "/resignation/#{SecureRandom.uuid}/confirm"

    assert_response :not_found
  end

  test 'reject for resignation' do
    get "/resignation/#{participation(:informed_resignation).activity_token}/reject"

    assert_response :success
    assert_predicate participation(:informed_resignation).reload, :status_joined?
  end

  test 'invalid token reject for resignation' do
    get "/resignation/#{SecureRandom.uuid}/reject"

    assert_response :not_found
  end

  test 'new for resignation' do
    get "/resignation/#{participation(:provide_resignation).activity_token}/new"

    assert_response :success
  end

  test 'invalid token new for resignation' do
    get "/resignation/#{SecureRandom.uuid}/new"

    assert_response :not_found
  end

  test 'create for resignation' do
    patch '/resignation/create',
          params: { participation: { activity_token: participation(:provide_resignation).activity_token,
                                     place_of_signature: 'aa', withdrawal_name_of_the_signatory: 'bb' } }

    assert_response :success
    assert_predicate participation(:provide_resignation).reload, :status_resignedly?
  end

  test 'invalid create for resignation' do
    patch '/resignation/create',
          params: { participation: { activity_token: participation(:provide_resignation).activity_token } }

    assert_response :bad_request
    assert_predicate participation(:provide_resignation).reload, :status_provide_resignation?
  end

  test 'invalid token create for resignation' do
    patch '/resignation/create', params: { participation: { activity_token: SecureRandom.uuid } }

    assert_response :not_found
  end
end
