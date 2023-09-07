require "test_helper"

class UserLoginTest < ActionDispatch::IntegrationTest
  test "usuario inválido no puede iniciar sesión" do
    invalid_user = { email: "correo@invalido.com", password: "contraseña_incorrecta" }

    get new_user_session_path
    assert_response :success

    post user_session_path, params: { user: invalid_user }
    assert_response :success

    assert_select "div.alert.alert-danger", "Correo o contraseña inválidos."
  end
end
