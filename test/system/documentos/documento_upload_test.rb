require "test_helper"

class DocumentoUploadTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:one)
    sign_in @user
    @request.env['action_controller.instance'] = @controller
  end

  test "usuario carga un documento inválido" do
    # Acceder a la página de carga de documentos
    get "/documentos/new"
    assert_response :success

    # Simular una petición HTTP POST a la ruta '/documentos' con un archivo inválido
    file = fixture_file_upload('documentos/COMPROBANTE_REFERENCIA_PAGO_10000.pdf', 'application/pdf')
    post "/documentos", params: { documento: { uploads: file } }

    # Comprobar que la respuesta HTTP tenga el código 422 (unprocessable entity)
    assert_response 422

    # Comprobar que la página muestra un mensaje de error indicando que el archivo es inválido
    assert_select 'div#error_explanation', text: /Archivo no válido/
  end
end
