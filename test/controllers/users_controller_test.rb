require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  fixtures :users
  setup do
    @user = users(:one)
    sign_in users(:one)
  end

  test "should get index" do
    get users_url
    assert_response :success
  end

  test "should get new" do
    get new_user_url
    assert_response :success
  end

  test "should create user" do
    assert_difference('User.count', 1) do
      post users_url, params: { user: { nombre: 'John', apellido_uno: 'Doe', apellido_dos: 'Smith', role: 'user', email: 'dan@example.com', password: 'password', password_confirmation: 'password' } }
    end
    assert_redirected_to user_url(User.last)
  end
  

  test "should show user" do
    get user_url(@user)
    assert_response :success
  end

  test "should get edit" do
    get edit_user_url(@user)
    assert_response :success
  end

  test "should update user" do
    patch user_url(@user), params: { user: { nombre: 'Jane' } }
    assert_redirected_to user_url(@user)
    @user.reload
    assert_equal 'Jane', @user.nombre
  end

  test "should destroy user" do
    assert_difference('User.count', -1) do
      delete user_url(@user)
    end

    assert_redirected_to users_url
  end
end
