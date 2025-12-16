# frozen_string_literal: true

require 'test_helper'

class WithdrawalControllerTest < ActionDispatch::IntegrationTest
  test 'confirm for withdrawal' do
    get "/withdrawal/#{participation(:informed_withdrawal).activity_token}/confirm"

    assert_response :success
    assert_predicate participation(:informed_withdrawal).reload, :status_provide_withdrawal?
  end

  test 'invalid token confirm for withdrawal' do
    get "/withdrawal/#{SecureRandom.uuid}/confirm"

    assert_response :not_found
  end

  test 'reject for withdrawal' do
    get "/withdrawal/#{participation(:informed_withdrawal).activity_token}/reject"

    assert_response :success
    assert_predicate participation(:informed_withdrawal).reload, :status_joined?
  end

  test 'invalid token reject for withdrawal' do
    get "/withdrawal/#{SecureRandom.uuid}/reject"

    assert_response :not_found
  end

  test 'new for withdrawal' do
    get "/withdrawal/#{participation(:provide_withdrawal).activity_token}/new"

    assert_response :success
  end

  test 'invalid token new for withdrawal' do
    get "/withdrawal/#{SecureRandom.uuid}/new"

    assert_response :not_found
  end

  test 'create for withdrawal' do
    patch '/withdrawal/create',
          params: { participation: { activity_token: participation(:provide_withdrawal).activity_token,
                                     withdrawal_effectiveness_date: Time.zone.today.to_s,
                                     place_of_signature: 'aa', withdrawal_name_of_the_signatory: 'bb' } }

    assert_response :redirect
    assert_redirected_to withdrawal_regex
    assert_predicate participation(:provide_withdrawal).reload, :status_withdrawal?
  end

  test 'invalid create for withdrawal' do
    patch '/withdrawal/create',
          params: { participation: { activity_token: participation(:provide_withdrawal).activity_token } }

    assert_response :bad_request
    assert_predicate participation(:provide_withdrawal).reload, :status_provide_withdrawal?
  end

  test 'invalid token create for withdrawal' do
    patch '/withdrawal/create', params: { participation: { activity_token: SecureRandom.uuid } }

    assert_response :not_found
  end

  private

  def withdrawal_regex
    /^mailto:\?to=email@leading_cooperation_partner.de&subject=Austrittserklärung aus dem Kooperationsverbund/
  end
end
