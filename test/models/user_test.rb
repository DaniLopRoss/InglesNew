require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "user has many documentos" do
    user = User.new
    assert_respond_to user, :documentos
  end

  test "user has one attached avatar" do
    user = User.new
    assert_respond_to user, :avatar
  end


  test "user is database authenticatable" do
    assert_includes User.devise_modules, :database_authenticatable
  end

  test "user is recoverable" do
    assert_includes User.devise_modules, :recoverable
  end

  test "user is rememberable" do
    assert_includes User.devise_modules, :rememberable
  end

  test "user is validatable" do
    assert_includes User.devise_modules, :validatable
  end
end
