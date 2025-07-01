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
      get "/admin/participations/#{participation(:one).id}/edit"

      assert_response :success
    end

    test 'unauthorized index without login' do
      get '/admin/participations'

      assert_redirected_to new_admin_logins_url
    end

    test 'unauthorized edit for no_access' do
      get "/admin/participations/#{participation(:one).id}/edit"

      assert_redirected_to new_admin_logins_url
    end

    test 'no update with empty params' do
      login username: 'admin'
      patch "/admin/participations/#{participation(:one).id}", params: { participation: { authority_name: '' } }

      assert_equal 'authority_name_one', participation(:one).reload.authority_name
    end

    test 'authorized update for admin' do
      login username: 'admin'
      patch "/admin/participations/#{participation(:one).id}",
            params: { participation: { authority_name: 'Update Test' } }

      assert_equal 'Update Test', participation(:one).reload.authority_name
    end

    def create_params
      { participation: { authority_name: 'Test', authority_address: 'test' } }
    end
  end
end
