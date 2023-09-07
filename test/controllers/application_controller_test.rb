require 'test_helper'

class ApplicationControllerTest < ActionController::TestCase
  include Devise::Test::IntegrationHelpers
  fixtures :users

  test "should redirect to correct path after sign in based on role" do
    user = users(:one)
    sign_in user
    get :index # o cualquier otra acción que requiera autenticación
    assert_response :success
    assert_redirected_to servicios_root_path if user.role == 'servicios'
    assert_redirected_to ingles_root_path if user.role == 'ingles'
    assert_redirected_to financieros_root_path if user.role == 'financieros'
    assert_redirected_to direccion_root_path if user.role == 'direccion'
  end
end
