require "test_helper"

class PaymentsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  fixtures :payments
  fixtures :documentos
  fixtures :users
 
  setup do
    @payment = payments(:one)
    @documento = documentos(:one)
    @user = users(:one)
    sign_in users(:one)
    #@user = User.create(email: "17161155@itoaxaca.edu.mx",nombre:"Luis", apellido_uno:"Lopez", apellido_dos:"Santos", role: "financieros")


  end

  test "should get index" do
    get payments_url
    assert_response :success
  end

  # test "should get index for user with financiero role" do
  #   user = users(:financieros)
  #   sign_in(user)
  #   get payments_url
  #   assert_response :success
  #   assert_equal [], assigns(:payments)
  # end
  
  # test "should get index for user with direccion role" do
  #   user = users(:direccion)
  #   sign_in(user)
  #   get payments_url
  #   assert_response :success
  #   assert_equal Payment.left_outer_joins(:certificate).where(certificate: { status: nil }), assigns(:payments)
  # end
  

  test "should get new" do
    get new_payment_url(documento_id: @documento.id)
    assert_response :success
  end

  test "should create payment" do
    assert_difference('Payment.count') do
      post payments_url, params: { payment: { documento_id: @documento.id, nombre: "COMPROBANTE_REFERENCIA_PAGO_10000 (1).pdf",status:"PAGADO", user_id: @user.id,uploads: [fixture_file_upload(Rails.root.join('test', 'fixtures', 'files', 'COMPROBANTE_REFERENCIA_PAGO_10000.pdf'), 'application/pdf')]  } }
    end

    assert_redirected_to payment_url(Payment.last)
  end

  test "should show payment" do
    get payment_url(@payment)
    assert_response :success
  end

  test "should get edit" do
    get edit_payment_url(@payment)
    assert_response :success
  end

  test "should update payment" do
    patch payment_url(@payment), params: { payment: { documento_id: @documento.id, nombre: "COMPROBANTE_REFERENCIA_PAGO_10000 (1).pdf",status:"PAGADO", user_id: @user.id, uploads: [fixture_file_upload(Rails.root.join('test', 'fixtures', 'files', 'COMPROBANTE_REFERENCIA_PAGO_10000.pdf'), 'application/pdf')]} }
    assert_redirected_to payment_url(@payment)
    @payment.reload
    assert_equal "PAGADO", @payment.status
  end


  

  # test "should update payment" do
  #   patch payment_url(@payment), params: { 
  #     payment: { 
  #       documento_id: @documento.id, 
  #       nombre: "COMPROBANTE_REFERENCIA_PAGO_10000 (1).pdf",
  #       status: "PAGADO", 
  #       user_id: @user.id  } 
  #   }
  #   assert_redirected_to payment_url(@payment)
  #   @payment.reload
  #   assert_equal "PAGADO", @payment.status
  
  #   # Cobertura para HTML
  #   assert_redirected_to payment_url(@payment), "Should redirect to payment after successful update"
  #   follow_redirect!
  #   assert_response :success
  #   assert_select "div.alert", "Payment was successfully updated."

    
  #   # Cobertura para JSON
  #   patch payment_url(@payment, format: :json), params: { 
  #     payment: { 
  #       documento_id: @documento.id, 
  #       nombre: "COMPROBANTE_REFERENCIA_PAGO_10000 (1).pdf",
  #       status: "PAGADO", 
  #       user_id: @user.id, 
  #       uploads: [fixture_file_upload(Rails.root.join('test', 'fixtures', 'files', 'COMPROBANTE_REFERENCIA_PAGO_10000.pdf'), 'application/pdf')] 
  #     } 
  #   }
  #   assert_response :success
  #   assert_equal "application/json", @response.media_type
  # end
  


  test "should destroy payment" do
    assert_difference('Payment.count', -1) do
      delete payment_url(@payment)
    end

    assert_redirected_to payments_url
  end
end
