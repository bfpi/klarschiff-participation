# frozen_string_literal: true

require 'test_helper'

class AdminUsersControllerControllerTest < ActionDispatch::IntegrationTest
  test 'authorized index for admin' do
    login username: 'admin'
    get '/admin/users'

    assert_response :success
  end

  test 'unauthorized edit for editor' do
    login username: 'editor'
    get "/admin/users/#{user(:one).id}/edit"

    assert_response :forbidden
  end

  test 'unauthorized index without login' do
    get '/admin/users'

    assert_redirected_to new_admin_logins_url
  end

  test 'unauthorized edit for no_access' do
    get "/admin/users/#{user(:one).id}/edit"

    assert_redirected_to new_admin_logins_url
  end

  test 'no update with empty params' do
    login username: 'admin'
    patch "/admin/users/#{user(:one).id}", params: { user: { name: '' } }

    assert_redirected_to edit_admin_user_path(user(:one))
    assert_equal 'name_one', user(:one).reload.name
  end

  test 'authorized destroy for admin' do
    login username: 'admin'
    delete "/admin/users/#{user(:one).id}"

    assert_redirected_to admin_users_path
  end

  test 'authorized new for admin' do
    login username: 'admin'
    get '/admin/users/new'

    assert_response :success
  end

  test 'no create without params for admin' do
    login username: 'admin'
    post '/admin/users'

    assert_response :bad_request
  end

  test 'authorized create for admin' do
    login username: 'admin'
    post '/admin/users', params: create_params

    created_user = User.order(:created_at).last

    assert_redirected_to edit_admin_user_path(created_user)

    assert_equal 'Test', created_user.name
  end

  test 'authorized update for admin' do
    login username: 'admin'
    patch "/admin/users/#{user(:one).id}",
          params: { user: { name: 'Update Test' } }

    assert_redirected_to edit_admin_user_path(user(:one))
    assert_equal 'Update Test', user(:one).reload.name
  end

  def create_params
    { user: { name: 'Test', login: 'test', password: 'Test1', password_confirmation: 'Test1' } }
  end
end
