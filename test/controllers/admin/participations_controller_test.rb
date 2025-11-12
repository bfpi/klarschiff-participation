# frozen_string_literal: true

require 'test_helper'

module Admin
  class ParticipationsControllerTest < ActionDispatch::IntegrationTest
    test 'authorized index for admin' do
      login username: 'admin'
      get '/admin/participations'

      assert_response :success
    end

    test 'authorized edit for editor' do
      login username: 'editor'
      get "/admin/participations/#{participation(:interested).id}/edit"

      assert_response :success
    end

    test 'unauthorized index without login' do
      get '/admin/participations'

      assert_redirected_to new_admin_logins_url
    end

    test 'unauthorized edit for no_access' do
      get "/admin/participations/#{participation(:interested).id}/edit"

      assert_redirected_to new_admin_logins_url
    end

    test 'no update with empty params' do
      login username: 'admin'
      patch "/admin/participations/#{participation(:interested).id}", params: { participation: { authority_name: '' } }

      assert_equal 'authority_name_interested', participation(:interested).reload.authority_name
    end

    test 'authorized update for admin' do
      login username: 'admin'
      patch "/admin/participations/#{participation(:interested).id}",
            params: { participation: { authority_name: 'Update Test' } }

      assert_equal 'Update Test', participation(:interested).reload.authority_name
    end

    test 'authorized start invalid inform for admin' do
      login username: 'admin'
      get "/admin/participations/#{participation(:informed).id}/inform"

      assert_response :not_found
    end

    test 'authorized start inform for admin' do
      login username: 'admin'
      get "/admin/participations/#{participation(:prepared).id}/inform"

      assert_redirected_to admin_participations_path
      assert_predicate participation(:prepared).reload, :status_informed?
    end

    test 'authorized start join inform for admin' do
      login username: 'admin'
      get "/admin/participations/#{participation(:informed).id}/join"

      assert_response :not_found
    end

    test 'authorized start join for admin' do
      login username: 'admin'
      get "/admin/participations/#{participation(:joining).id}/join"

      assert_redirected_to admin_participations_path
      assert_predicate participation(:joining).reload, :status_joined?
    end

    test 'authorized start invalid withdrawal for admin' do
      login username: 'admin'
      get "/admin/participations/#{participation(:informed).id}/withdrawal"

      assert_response :not_found
    end

    test 'authorized start withdrawal for admin' do
      login username: 'admin'
      get "/admin/participations/#{participation(:joined).id}/withdrawal"

      assert_redirected_to admin_participations_path
      assert_predicate participation(:joined).reload, :status_informed_withdrawal?
    end

    test 'authorized start invalid withdrawal_check for admin' do
      login username: 'admin'
      get "/admin/participations/#{participation(:informed).id}/withdrawal_check"

      assert_response :not_found
    end

    test 'authorized start withdrawal_check for admin' do
      login username: 'admin'
      get "/admin/participations/#{participation(:withdrawal).id}/withdrawal_check"

      assert_redirected_to admin_participations_path
      assert_predicate participation(:withdrawal).reload, :status_withdrawal_check?
    end

    test 'authorized start invalid withdraw for admin' do
      login username: 'admin'
      get "/admin/participations/#{participation(:informed).id}/withdraw"

      assert_response :not_found
    end

    test 'authorized start withdraw for admin' do
      login username: 'admin'
      get "/admin/participations/#{participation(:withdrawal_check).id}/withdraw"

      assert_redirected_to admin_participations_path
      assert_predicate participation(:withdrawal_check).reload, :status_withdraw?
    end

    def create_params
      { participation: { authority_name: 'Test', authority_address: 'test' } }
    end
  end
end
