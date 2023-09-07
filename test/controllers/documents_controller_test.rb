require "test_helper"

class DocumentosControllerTest < ActionDispatch::IntegrationTest
    include Devise::Test::IntegrationHelpers
    fixtures :documentos
    fixtures :users
    setup do
    @user = users(:one) # Asegúrate de tener un usuario de prueba en tu archivo fixtures
    sign_in @user # Inicia sesión como el usuario de prueba
  end

  test "should create documento" do
    assert_difference("Documento.count") do
      pdf_file = fixture_file_upload(Rails.root.join('test', 'fixtures', 'files', 'CLE_0001202317160858.pdf'),
        'application/pdf')
      xml_file = fixture_file_upload(Rails.root.join('test', 'fixtures', 'files', 'CLE_0001202317160858.xml'),
      'application/xml')

      post documentos_url, params: {
        documento: {
          pdf_upload: pdf_file,
          xml_upload: xml_file,
          serial: "0004202318161003",
          no_oficio: "DGTV-CLE-0004/2023", 
          asunto: "Constancia de Acreditación del Idioma Inglés.",
          plan:"TecNM-SEyV-DVIA-CNLE-ACT-03/21-ITO-32",
          nombre: "Documento de prueba",
          numero_de_control: "17161155",
          carrera:"Sistemas",
          nivel: "B1",
          periodo: "agosto-diciembre de 2022.",
          md5: "8TWlNFJrSmL",
          cadena_comprobacion: "DGTV_CLE_0001_2023_17160858_0001202317160858_186.96.178.153_2023_03_14_19_58_09",
          fecha:"2023-03-01",
          referencia:"CLE_0001202317160858.pdf",
          user_id: @user.id,
          status:1,
          user_update_id:50
        }
      }
    end

    assert_redirected_to documento_url(Documento.last)
    assert_equal "Documento se ha creado con éxito.", flash[:notice]

    # Verificar que los datos del documento se hayan guardado correctamente
    documento = Documento.last
    assert_equal @user, documento.user
    assert_equal "serial_value", documento.serial
    assert_equal "no_oficio_value", documento.no_oficio
    # ...
    # Verificar los demás campos del documento

    # Verificar que los archivos de Active Storage se hayan adjuntado correctamente
    assert_equal 1, documento.uploads.count
    assert_equal 1, documento.xml_uploads.count
  end

  test "should not create documento if PDF and XML files don't match" do
    assert_no_difference("Documento.count") do
      pdf_file = fixture_file_upload("files/document.pdf", "application/pdf")
      xml_file = fixture_file_upload("files/incorrect_document.xml", "application/xml")

      post documentos_url, params: {
        documento: {
          pdf_upload: pdf_file,
          xml_upload: xml_file
        }
      }
    end

    assert_redirected_to new_documento_url
    assert_equal "El archivo PDF y el archivo XML no coinciden. Por favor, sube el archivo correcto.", flash[:alert]

    # Verificar que no se haya creado ningún documento ni adjuntado ningún archivo
    assert_equal 0, Documento.count
    assert_equal 0, ActiveStorage::Attachment.count
  end
end
