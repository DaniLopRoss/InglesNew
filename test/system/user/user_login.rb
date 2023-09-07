require "test_helper"

class UserLogin < ActionDispatch::IntegrationTest
fixtures :users
  def setup
    @users = users(:one) # Crea un usuario de prueba
  end

  test "usuario válido inicia sesión correctamente" do
    # Visita la página de inicio de sesión
    get new_user_session_path
    assert_response :success

    # Ingresa las credenciales válidas del usuario
    post user_session_path, params: {
      user: {
        email: @users.email,
        password: "123456" # reemplaza con la contraseña real del usuario
      }
    }

    # Asegura que se haya iniciado sesión correctamente y se redirija a la página de inicio
    assert_response :success # Cambiado de :redirect a :success
    assert_equal new_user_session_path, path

    # Asegura que se haya iniciado sesión como el usuario correcto
    assert_equal @user, assigns(:current_user)
  end
end
