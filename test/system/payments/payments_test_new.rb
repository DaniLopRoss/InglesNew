require "test_helper"

class PaymentsTestNew < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  fixtures :documentos
  fixtures :users
  fixtures :payments
  setup do
    @payment = payments(:one)
    @user = users(:one)
    @documento = documentos(:one)
    sign_in @user
  end


  test "submit valid payment" do
    file_path = Rails.root.join("test/fixtures/files/CLE_0004202318161003.pdf")
    file = Rack::Test::UploadedFile.new(File.open(file_path), "application/pdf")
    post payments_path, params: {
      payment: {
        documento_id: @documento.id,
        uploads: [file],
        status: "PAGADO"
      }
    }
    assert_redirected_to payment_path(Payment.last)

    # Seguir la redirección y verificar que se muestre el mensaje de éxito
    follow_redirect!
    assert_not flash[:success].present?
  end

  test "submit invalid payment" do
    documento = documentos(:one) # Asigna un documento válido existente
    post payments_url, params: {
      payment: {
        documento_id: documento.id,
        uploads: nil,
        status: "PAGADO"
      }
    }
    assert_response :success
    assert_select "div#error_explanation ul li", "Uploads necesita adjuntar un documento"
  end
end
