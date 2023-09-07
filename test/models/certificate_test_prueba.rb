require "test_helper"

class CertificateTestPrueba < ActiveSupport::TestCase
  test "belongs to a payment" do
    payment = Payment.create(nombre: "Payment")
    certificate = Certificate.create(nombre: "Certificate", payment: payment)
    assert_equal payment, certificate.payment
  end

  test "has many uploads" do
    certificate = Certificate.create(nombre: "Certificate")
    assert certificate.uploads.empty?
    certificate.uploads.attach(io: StringIO.new("Test"), filename: "test.txt", content_type: "text/plain")
    assert_not certificate.uploads.empty?
  end

  test "has one documento through payment" do
   
    documento = Documento.create(serial: "0004202318161003",no_oficio: "DGTV-CLE-0004/2023", asunto: "Constancia de Acreditación del Idioma Inglés.", plan:"TecNM-SEyV-DVIA-CNLE-ACT-03/21-ITO-32", nombre: "MARCOS ÁNGEL JMICA", numero_de_control: "17161155", carrera:"Sistemas", nivel: "B1", periodo: "agosto-diciembre de 2022.", md5: "8TWlNFJrSmL", cadena_comprobacion: "DGTV_CLE_0001_2023_17160858_0001202317160858_186.96.178.153_2023_03_14_19_58_09", fecha:"2023-03-01", user_id: 980190962, referencia:"CLE_0001202317160858.pdf")
    payment =Payment.create(nombre: "Pago1", status: "Pagado", documento_id: documento.id, user_id: 980190962)
    payment.documento = documento
    certificate = Certificate.create(nombre: "Certificate", payment_id: payment.id, user_id:980190962)
    certificate.payment = payment
    assert_equal payment, certificate.payment
  end


  test "belongs to a user" do
    user = User.create(email: "user@example.com")
    certificate = Certificate.create(nombre: "Certificate", user: user)
    assert_equal user, certificate.user
  end


  test "validates presence of uploads" do
    certificate = Certificate.new
    certificate.valid?
  
    assert_includes certificate.errors[:uploads], "necesita adjuntar un documento"
  end
  
end
