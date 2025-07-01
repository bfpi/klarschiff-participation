# frozen_string_literal: true

require 'test_helper'

module Admin
  class MasterDataControllerTest < ActionDispatch::IntegrationTest
    test 'authorized edit for editor' do
      login username: 'editor'
      get '/admin/master_data/edit'

      assert_response :success
    end

    test 'unauthorized edit for no_access' do
      get '/admin/master_data/edit'

      assert_redirected_to new_admin_logins_url
    end

    test 'no update with empty params' do
      login username: 'admin'
      patch '/admin/master_data', params: { master_data: { leading_cooperation_partner_name: '' } }

      assert_equal 'name', master_data(:one).reload.leading_cooperation_partner_name
    end

    test 'authorized update for admin' do
      login username: 'admin'
      patch '/admin/master_data',
            params: { master_data: { leading_cooperation_partner_name: 'Update Test' } }

      assert_equal 'Update Test', master_data(:one).reload.leading_cooperation_partner_name
    end

    def create_params
      { master_data: {
        leading_cooperation_partner_name: 'Update Test',
        leading_cooperation_partner_address: 'Update Test',
        leading_cooperation_partner_email: 'UpdateTest@example.com'
      } }
    end
  end
end
