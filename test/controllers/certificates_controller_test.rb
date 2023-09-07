require "test_helper"

class CertificatesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  fixtures :payments
  fixtures :certificates
  fixtures :users
  setup do
    @certificate = certificates(:one)
    @payment = payments(:one)
    @user = users(:one)
    sign_in users(:one)
  end

  test "should get index" do
    get certificates_url
    assert_response :success
  end

  test "should get new" do
    get new_certificate_url(payment_id: @payment.id)
    assert_response :success
  end

  test "should create certificate" do
    assert_difference('Certificate.count') do
      post certificates_url,  params: { certificate: {payment_id: @payment.id, nombre: "CLE_0002202318160424.pdf",status: 1, user_id: @user.id, uploads: [fixture_file_upload(Rails.root.join('test', 'fixtures', 'files', 'CLE_0002202318160424.pdf'), 'application/pdf')] } }
    end

    assert_redirected_to certificate_url(Certificate.last)
  end

  test "should show certificate" do
    get certificate_url(@certificate)
    assert_response :success
  end

  test "should get edit" do
    get edit_certificate_url(@certificate)
    assert_response :success
  end

  test "should update certificate" do
    patch certificate_url(@certificate), params: { certificate: {payment_id: @payment.id, nombre: "CLE_0002202318160424.pdf",status: 1, user_id: @user.id, uploads: [fixture_file_upload(Rails.root.join('test', 'fixtures', 'files', 'COMPROBANTE_REFERENCIA_PAGO_10000.pdf'), 'application/pdf')]}}
    assert_redirected_to certificate_url(@certificate)
    @certificate.reload
    assert_equal "CLE_0002202318160424.pdf", @certificate.nombre
  end

  test "should destroy certificate" do
    assert_difference("Certificate.count", -1) do
      delete certificate_url(@certificate)
    end

    assert_redirected_to certificates_url
  end
end
