require "test_helper"

class DocumentosControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  fixtures :documentos
  fixtures :users
  setup do
    @documento = documentos(:one)
    @user = users(:one)
    #@file = fixture_file_upload('CLE_0004202318161003.pdf', 'application/pdf')
    sign_in @user
  end

  test "should get index" do
    get documentos_url
    assert_response :success
  end

  # test "should get show" do
  #   get documento_url(@documento)
  #   assert_response :success
  # end

  test "should get new" do
    get new_documento_url
    assert_response :success
  end


 
  # test "should create documento" do
  #   assert_difference('Documento.count') do
  #     post documentos_url, params: {
  #       documento: {
  #         serial: "0004202318161003",
  #         no_oficio: "DGTV-CLE-0004/2023", 
  #         asunto: "Constancia de Acreditación del Idioma Inglés.",
  #         plan:"TecNM-SEyV-DVIA-CNLE-ACT-03/21-ITO-32",
  #         nombre: "Documento de prueba",
  #         numero_de_control: "17161155",
  #         carrera:"Sistemas",
  #         nivel: "B1",
  #         periodo: "agosto-diciembre de 2022.",
  #         md5: "8TWlNFJrSmL",
  #         cadena_comprobacion: "DGTV_CLE_0001_2023_17160858_0001202317160858_186.96.178.153_2023_03_14_19_58_09",
  #         fecha:"2023-03-01",
  #         user_id: @user.id,
  #         referencia:"CLE_0001202317160858.pdf",
  #         uploads: [
  #           fixture_file_upload(
  #             Rails.root.join('test', 'fixtures', 'files', 'CLE_0001202317160858.pdf'),
  #             'application/pdf'
  #           )
  #         ]
  #       }
  #     }
  #   end
  
  #   assert_redirected_to documento_url(Documento.last)




  test "should create documento" do
    assert_difference('Documento.count') do
      post documentos_url, params: {
        documento: {
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
          user_update_id:@user.user_update_id
          
        
        }
      }
    end
  
    assert_redirected_to documento_url(Documento.last)
  end







  # test "should create documento" do
  #   assert_difference('Documento.count') do
  #     post documentos_url, params: {
  #       documento: {
  #         serial: "0004202318161003",
  #     no_oficio: "DGTV-CLE-0004/2023", 
  #     asunto: "Constancia de Acreditación del Idioma Inglés.", 
  #     plan:"TecNM-SEyV-DVIA-CNLE-ACT-03/21-ITO-32", 
  #     nombre: "MARCOS ÁNGEL JMICA", 
  #     numero_de_control: "17161155", 
  #     carrera:"Sistemas",
  #     nivel: "B1", 
  #     periodo: "agosto-diciembre de 2022.", 
  #     md5: "8TWlNFJrSmL", 
  #     cadena_comprobacion: "DGTV_CLE_0001_2023_17160858_0001202317160858_186.96.178.153_2023_03_14_19_58_09", 
  #     fecha:"2023-03-01", 
  #     user_id: 980190962, 
  #     referencia:"CLE_0001202317160858.pdf",
  #     uploads: [fixture_file_upload(Rails.root.join('test', 'fixtures', 'files', 'COMPROBANTE_REFERENCIA_PAGO_10000.pdf'), 'application/pdf')],
  #     xml_uploads:[
  #       fixture_file_upload(
  #         Rails.root.join('test', 'fixtures', 'files', 'CLE_0001202317160858.xml'),
  #         'application/xml')]
  #       }
  #     }
  #   end

  #   assert_redirected_to documento_url(Documento.last)
  # end




  # end



  # test "should read PDF file" do
  #   # Cargar el archivo de prueba
  #  # pdf_file = fixture_file_upload('files/CLE_0004202318161003.pdf', 'application/pdf')
  #   file_path = Rails.root.join("test/fixtures/files/CLE_0004202318161003.pdf")
  #   file = Rack::Test::UploadedFile.new(File.open(file_path), "application/pdf")

  #   # Crear un nuevo objeto Documento y asociar el archivo subido
  #   documento = Documento.new
  #   documento.archivo_pdf.attach(file)

  #   # Realizar la lectura del archivo PDF
  #   documento.pdf_reader

  #   # Verificar que los datos se hayan leído correctamente
  #   assert_equal "0004202318161003", documento.serial_number
  #   assert_equal "2023-03-01 10:00:00", documento.fecha.to_s(:db)
  #   assert_equal "Constancia de Acreditación del Idioma Inglés.", documento.asunto
  #   assert_equal "TecNM-SEyV-DVIA-CNLE-ACT-03/21-ITO-32", documento.plan
  #   assert_equal "", documento.nombre
  #   assert_equal "18161003", documento.numero_de_control
  #   assert_equal "ING. QUÍMICA", documento.carrera
  #   assert_equal "B1", documento.nivel
  #   assert_equal "agosto-diciembre de 2022.", documento.periodo
  #   assert_equal "8TWlNFJrSmLs/r+OPMQiZg==", documento.md5
  #   assert_equal "CLE_0004202318161003.pdf", documento.referencia
  #   # ...
  # end





  # test "create method should parse uploaded PDF and save attributes to database" do
  #   #pdf = fixture_file_upload("fixtures/files/CLE_0004202318161003.pdf", "application/pdf")
  #   #@file = fixture_file_upload('CLE_0004202318161003.pdf', 'application/pdf')  
  #   pdf = fixture_file_upload(Rails.root.join('test', 'fixtures', 'files', 'CLE_0004202318161003.pdf'), 'application/pdf')


  #   assert_difference -> { Documento.count } do
  #     post documentos_path, params: { documento: { uploads: [pdf] } }
  #  end

  #   documento = Documento.last
  #   assert_equal "0004202318161003", documento.serial
  #   assert_equal "DGTV-CLE-0004/2023", documento.no_oficio
  #   assert_equal "Constancia de Acreditación del Idioma Inglés.", documento.asunto
  #   assert_equal "TecNM-SEyV-DVIA-CNLE-ACT-03/21-ITO-32", documento.plan
  #   assert_equal "MARCOS ÁNGEL JIMÉNEZ MIGUEL", documento.nombre
  #   assert_equal "18161003", documento.numero_de_control
  #   assert_equal "ING. QUÍMICA", documento.carrera
  #   assert_equal "B1", documento.nivel
  #   assert_equal "agosto-diciembre de 2022.", documento.periodo
  #   assert_equal "2023-03-01", documento.fecha
  #   assert_equal "8TWlNFJrSmLs/r+OPMQiZg==", documento.md5
  #   assert_equal "DGTV_CLE_0004_2023_18161003_0004202318161003_186.96.178.153_2023_03_14_20_06_48", documento.cadena_comprobacion
  #   assert_equal "CLE_0004202318161003.pdf", documento.referencia

  #   assert File.exist?(Rails.root.join("public", "uploads", "#{documento.nombre}.xml"))
  # end





  # test "should create documento" do
  #   assert_difference('Documento.count') do
  #     file = fixture_file_upload('test/fixtures/files/CLE_0004202318161003.pdf', 'application/pdf')
  #     post documentos_url, params: { 
  #       documento: { 
  #         serial: "0004202318161003",
  #         no_oficio: "DGTV-CLE-0004/2023", 
  #         asunto: "Constancia de Acreditación del Idioma Inglés.",
  #         plan:"TecNM-SEyV-DVIA-CNLE-ACT-03/21-ITO-32",
  #         nombre: "Documento de prueba",
  #         numero_de_control: "17161155",
  #         carrera:"Sistemas",
  #         nivel: "B1",
  #         periodo: "agosto-diciembre de 2022.",
  #         md5: "8TWlNFJrSmL",
  #         cadena_comprobacion: "DGTV_CLE_0001_2023_17160858_0001202317160858_186.96.178.153_2023_03_14_19_58_09",
  #         fecha:"2023-03-01",
  #         user_id: @user.id,
  #         referencia:"CLE_0001202317160858.pdf",
  #      uploads: [file] # agrega el archivo adjunto a la solicitud
  #       } 
  #     }
  #   end
  #   assert_redirected_to documento_url(Documento.last)
  #   assert_equal "Documento de prueba", Documento.last.nombre
  # end



  
  test "should get edit" do
    get edit_documento_url(@documento)
    assert_response :success
  end

  test "should update documento" do
    patch documento_url(@documento), params: {documento: { serial: "0004202318161003",no_oficio: "DGTV-CLE-0004/2023", asunto: "Constancia de Acreditación del Idioma Inglés.", plan:"TecNM-SEyV-DVIA-CNLE-ACT-03/21-ITO-32", nombre: "MARCOS ÁNGEL JIMÉNEZ", numero_de_control: "17161155", carrera:"Sistemas", nivel: "B1", periodo: "agosto-diciembre de 2022.", md5: "8TWlNFJrSmL", cadena_comprobacion: "DGTV_CLE_0001_2023_17160858_0001202317160858_186.96.178.153_2023_03_14_19_58_09", fecha:"2023-03-01",  user_id: @user.id, referencia:"CLE_0002202318160424.pdf",  uploads: [
      fixture_file_upload(
        Rails.root.join('test', 'fixtures', 'files', 'CLE_0001202317160858.pdf'),
        'application/pdf'
      )
    ],
    xml_uploads:[
      fixture_file_upload(
        Rails.root.join('test', 'fixtures', 'files', 'CLE_0001202317160858.xml'),
        'application/xml')]  
    } }
    assert_redirected_to documento_url(@documento)
    @documento.reload
    assert_equal "MARCOS ÁNGEL JIMÉNEZ", @documento.nombre
    assert_equal "Constancia de Acreditación del Idioma Inglés.", @documento.asunto
  end

  test "should destroy documento" do
     assert_difference('Documento.count', -1) do
      delete documento_url(@documento)
    end
    assert_redirected_to documentos_url
  end
end
