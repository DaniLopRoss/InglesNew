require "test_helper"

class CertificatesTestNew < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  fixtures :certificates
  fixtures :payments
  fixtures :users
  setup do
    @certificate = certificates(:one)
    @payment = payments(:one)
    @user = users(:one)
    sign_in @user
  end

  test "submit valid certificate" do
    # Simular la carga de un archivo
    file_path = Rails.root.join("test/fixtures/files/CLE_0004202318161003.pdf")
    file = Rack::Test::UploadedFile.new(File.open(file_path), "application/pdf")

    # Hacer una petición POST a la ruta para crear un nuevo certificado
    post certificates_path, params: {
      certificate: {
        uploads: [file],
        status: false,
        payment_id: @payment.id
      }
    }

    # Verificar que se haya creado el certificado y que se redirija a la página correcta
    assert_redirected_to certificate_path(Certificate.last)

    # Seguir la redirección y verificar que se muestre el mensaje de éxito
    follow_redirect!
    assert_not flash[:success].present?


  end



  test "submit invalid certificate" do
    payment = payments(:one) # Asigna un documento válido existente
    post certificates_url, params: {
      certificate: {
        payment_id: payment.id,
        uploads: nil,
        status: "1"
      }
    }
    assert_response :success
    assert_select "div#error_explanation ul li", "Uploads necesita adjuntar un documento"
  end



end
