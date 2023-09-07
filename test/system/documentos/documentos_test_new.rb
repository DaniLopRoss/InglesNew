require "test_helper"

class DocumentosTestNew < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  fixtures :documentos
  fixtures :users
  setup do
    @documento = documentos(:one)
    @user = users(:one)
    #@file = fixture_file_upload('CLE_0004202318161003.pdf', 'application/pdf')
    sign_in @user
  end

  test "submit valid documento" do
    file_path = Rails.root.join("test/fixtures/files/CLE_0004202318161003.pdf")
    file = Rack::Test::UploadedFile.new(File.open(file_path), "application/pdf")
    post documentos_path, params: {
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
                user_id: @user.id,
                referencia:"CLE_0001202317160858.pdf",
        uploads: [file]
       
      }
    }
    assert_redirected_to documento_path(Documento.last)

    # Seguir la redirección y verificar que se muestre el mensaje de éxito
    follow_redirect!
    assert_not flash[:success].present?
  end

  # test "crear documento inválido" do
  #   user = users(:one)
  #  post documentos_url, params: {
  #     payment: {
  #               serial: "0004202318161003",
  #               no_oficio: "DGTV-CLE-0004/2023", 
  #               asunto: "Constancia de Acreditación del Idioma Inglés.",
  #               plan:"TecNM-SEyV-DVIA-CNLE-ACT-03/21-ITO-32",
  #               nombre: "Documento de prueba",
  #               numero_de_control: "17161155",
  #               carrera:"Sistemas",
  #               nivel: "B1",
  #               periodo: "agosto-diciembre de 2022.",
  #               md5: "8TWlNFJrSmL",
  #               cadena_comprobacion: "DGTV_CLE_0001_2023_17160858_0001202317160858_186.96.178.153_2023_03_14_19_58_09",
  #               fecha:"2023-03-01",
  #               user_id: @user.id,
  #               referencia:"CLE_0001202317160858.pdf",
  #              uploads: nil
        
  #     }
  #   }
  #   assert_response :success
  #   assert_select "div#error_explanation ul li", "Uploads necesita adjuntar un documento"
  # end

  
end
