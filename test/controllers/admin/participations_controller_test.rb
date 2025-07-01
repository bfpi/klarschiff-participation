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

    test 'unauthorized to update leading_cooperation_partner for editor' do
      login username: 'editor'
      patch "/admin/participations/#{participation(:one).id}", params: update_params

      reloaded = participation(:one).reload

      assert_empty reloaded.leading_cooperation_partner_name
      assert_empty reloaded.leading_cooperation_partner_address
      assert_empty reloaded.leading_cooperation_partner_email
    end

    test 'authorized to update leading_cooperation_partner for admin' do
      login username: 'admin'
      patch "/admin/participations/#{participation(:one).id}", params: update_params

      reloaded = participation(:one).reload

      assert_equal 'Update Test',  reloaded.leading_cooperation_partner_name
      assert_equal 'Update Test',  reloaded.leading_cooperation_partner_address
      assert_equal 'UpdateTest@example.com', reloaded.leading_cooperation_partner_email
    end

    def create_params
      { participation: { authority_name: 'Test', authority_address: 'test' } }
    end

    def update_params
      { participation: {
        leading_cooperation_partner_name: 'Update Test',
        leading_cooperation_partner_address: 'Update Test',
        leading_cooperation_partner_email: 'UpdateTest@example.com'
      } }
    end
  end
end
