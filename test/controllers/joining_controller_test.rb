# frozen_string_literal: true

require 'test_helper'

class JoiningControllerTest < ActionDispatch::IntegrationTest
  test 'confirm for joining' do
    get "/joining/#{participation(:informed).activity_token}/confirm"

    assert_response :success
    assert_predicate participation(:informed).reload, :status_provide?
  end

  test 'invalid token confirm for joining' do
    get "/joining/#{SecureRandom.uuid}/confirm"

    assert_response :not_found
  end

  test 'reject for joining' do
    get "/joining/#{participation(:informed).activity_token}/reject"

    assert_response :success
    assert_predicate participation(:informed).reload, :status_call_back?
  end

  test 'invalid token reject for joining' do
    get "/joining/#{SecureRandom.uuid}/reject"

    assert_response :not_found
  end

  test 'new for joining' do
    get "/joining/#{participation(:provide).activity_token}/new"

    assert_response :success
  end

  test 'invalid token new for joining' do
    get "/joining/#{SecureRandom.uuid}/new"

    assert_response :not_found
  end

  test 'create for joining' do
    patch '/joining/create',
          params: { participation: { activity_token: participation(:provide).activity_token, place_of_signature: 'aa',
                                     name_of_the_signatory: 'bb' } }

    assert_response :redirect
    assert_redirected_to joining_regex
    assert_predicate participation(:provide).reload, :status_joining?
  end

  test 'invalid create for joining' do
    patch '/joining/create', params: { participation: { activity_token: participation(:provide).activity_token } }

    assert_response :bad_request
    assert_predicate participation(:provide).reload, :status_provide?
  end

  test 'invalid token create for joining' do
    patch '/joining/create', params: { participation: { activity_token: SecureRandom.uuid } }

    assert_response :not_found
  end

  private

  def joining_regex
    /^mailto:\?to=email&subject=Beitrittserklärung zum Kooperationsverbund „KLARSCHIFF-MV“&body=Von/
  end
end
