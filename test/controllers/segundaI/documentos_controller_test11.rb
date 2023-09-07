require 'minitest/autorun'

class DocumentosControllerTest < ActiveSupport::TestCase
  def setup
    @controller = DocumentosController.new
    @user_direccion = User.new(role: "direccion")
    @user_gestion = User.new(role: "gestion")
    @user_financieros = User.new(role: "financieros")
    @user_otros = User.new(role: "otros")
    @documento = Documento.new(id: 1, user_update_id: 2, updated_at: Time.now)
    @user = User.new(id: 2, nombre: "Juan Jose ", apellido_uno: "Cruz", apellido_dos: "Perez")
    @payment = Payment.new(documento_id: 1)
  end

  def test_index_direccion_role
    @controller.stub(:current_user, @user_direccion) do
      Documento.stub_chain(:sin_pago, :where, :to_a, :empty?, false) do
        Documento.stub_chain(:sin_pago, :where, :to_a, :empty?, true) do
          Documento.stub_chain(:sin_pago, :where, :where, :to_a) do
            @controller.index
            assert_equal Documento.sin_pago.where(status: true), @controller.instance_variable_get(:@documentos)
          end
        end
      end
    end
  end

  def test_index_gestion_role
    @controller.stub(:current_user, @user_gestion) do
      Documento.stub_chain(:joins, :where, :where, :to_a, :empty?, false) do
        Documento.stub_chain(:joins, :where, :where, :to_a, :empty?, true) do
          Documento.stub_chain(:joins, :where, :where, :to_a) do
            @controller.index
            assert_equal Documento.joins(:payment).where.not(payments: { id: nil }).where(documentos: { status: false }), @controller.instance_variable_get(:@documentos)
          end
        end
      end
    end
  end

  def test_index_financieros_role
    @controller.stub(:current_user, @user_financieros) do
      Documento.stub_chain(:sin_pago, :where, :to_a, :empty?, false) do
        Documento.stub_chain(:sin_pago, :where, :to_a, :empty?, true) do
          Documento.stub_chain(:sin_pago, :where, :where, :to_a) do
            @controller.index
            assert_equal Documento.sin_pago.where(comment: nil), @controller.instance_variable_get(:@documentos)
          end
        end
      end
    end
  end

  def test_index_otros_role
    @controller.stub(:current_user, @user_otros) do
      Documento.stub_chain(:where, :to_a) do
        @controller.index
        assert_equal Documento.where(comment: nil), @controller.instance_variable_get(:@documentos)
      end
    end
  end

  def test_show_with_user_update
    Documento.stub(:find, @documento) do
      User.stub(:find, @user) do
        @controller.stub(:params, id: 1) do
          Payment.stub(:includes, @payment) do
            @controller.show
            assert_equal "#{@user.nombre} #{@user.apellido_uno} #{@user.apellido_dos}",
                         @controller.instance_variable_get(:@user_name)
            assert_equal @documento.updated_at.in_time_zone("Mexico City").strftime("%Y-%m-%d %H:%M:%S"),
                         @controller.instance_variable_get(:@documento_date)
            assert_equal @payment, @controller.instance_variable_get(:@payment)
          end
        end
      end
    end
  end

  def test_show_without_user_update
    @documento.user_update_id = nil
    Documento.stub(:find, @documento) do
      @controller.stub(:params, id: 1) do
        Payment.stub(:includes, @payment) do
          @controller.show
          assert_equal "Documento no validado", @controller.instance_variable_get(:@user_name)
          assert_equal @documento.updated_at.in_time_zone("Mexico City").strftime("%Y-%m-%d %H:%M:%S"),
                       @controller.instance_variable_get(:@documento_date)
          assert_equal @payment, @controller.instance_variable_get(:@payment)
        end
      end
    end
  end

  @documentos = [Documento.new(id: 1, status: true), Documento.new(id: 2, status: false)]

 def test_verified_gestion
    Documento.stub(:joins, @documentos) do
      Payment.stub(:where, @documentos) do
        @controller.verified_gestion
        assert_equal @documentos, @controller.instance_variable_get(:@documentos)
      end
    end
  end

  def test_documentos_invalidos
    Documento.stub(:where, @documentos) do
      @controller.documentos_invalidos
      assert_equal @documentos, @controller.instance_variable_get(:@documentos)
    end
  end


  def test_create
    documento_params = {
      serial: '0 0 1 4 2 0 2 3 1 9 1 6 1 1 3 3',
      no_oficio: 'DGTV-CLE-0014/2023',
      asunto: 'Constancia de Acreditación del Idioma Inglés',
      plan: 'TecNM-SEyV-DVIA-CNLE-ACT-03/21-ITO-32',
      nombre: 'NANCY LÓPEZ RUÍZ',
      numero_de_control: '19161133',
      carrera: 'ING. QUÍMICA',
      nivel: 'B1',
      periodo: 'agosto-diciembre de 2022',
      md5: 'abcdef123456',
      cadena_comprobacion: 'DGTV_CLE_0014_2023_19161133_0014202319161133_187.217.220.170_2023_05_02_12_20_07',
      fecha: Date.today,
      user_id: 1,
      referencia: 'documento.pdf',
      status: 0,
      user_update_id: nil,
      comment: nil,
      uploads: [fixture_file_upload('test/fixtures/documento.pdf', 'application/pdf')],
      xml_uploads: [fixture_file_upload('test/fixtures/documento.xml', 'text/xml')]
    }

    assert_difference('Documento.count') do
      assert_difference('ActiveStorage::Attachment.count', 2) do
        post :create, params: { documento: documento_params }
      end
    end

    assert_redirected_to Documento.last
    assert_equal 'Documento se ha creado con éxito.', flash[:notice]
  end
end
 def test_create_existing_document
    Documento.stub(:find_by, Documento.new) do
      @controller.stub(:redirect_to, nil) do
        @controller.stub(:alert=, nil) do
          @controller.instance_variable_set(:@documento, Documento.new)
          @controller.params = ActionController::Parameters.new(documento: @documento_params)

          @controller.create

          assert_equal 'El documento ya existe en la base de datos.', @controller.flash[:alert]
        end
      end
    end
  end
  def test_create_file_mismatch
    Documento.stub(:save, true) do
      @controller.stub(:redirect_to, nil) do
        @controller.stub(:alert=, nil) do
          @controller.instance_variable_set(:@documento, Documento.new)
          @controller.params = ActionController::Parameters.new(documento: @documento_params.merge(referencia: 'nombre_archivo_mismatch.pdf'))

          @controller.create

          assert_equal 'El archivo PDF y el archivo XML no coinciden. Por favor, sube el archivo correcto.', @controller.flash[:alert]
        end
      end
    end
  end
   @documento = Documento.new(id: 1)
    @documento_params = {
      serial: '12345',
      no_oficio: 'ABC123',
      asunto: 'Asunto actualizado',
      plan: 'Plan actualizado',
      nombre: 'Nombre actualizado',
      numero_de_control: '987654321',
      carrera: 'Carrera actualizada',
      nivel: 'Nivel actualizado',
      periodo: 'Periodo actualizado',
      md5: 'md5hash',
      cadena_comprobacion: 'Cadena de comprobación actualizada',
      fecha: Date.today,
      user_id: 1,
      referencia: 'nombre_archivo_actualizado.pdf',
      status: 1,
      user_update_id: nil,
      comment: 'Comentario actualizado',
      uploads: [],
      xml_uploads: []
    }
    @params = ActionController::Parameters.new(documento: @documento_params)
    @current_user = User.new(id: 1, role: 'gestion')
  end
  def test_update_success
    @documento.stub(:update, true) do
      @documento.stub(:user_update_id=, nil) do
        @documento.stub(:save, true) do
          User.stub(:find, @current_user) do
            UserMailer.stub(:document_verified_email, nil) do
              @controller.stub(:redirect_to, nil) do
                @controller.stub(:notice=, nil) do
                  @controller.instance_variable_set(:@documento, @documento)
                  @controller.params = @params
                  @controller.stub(:current_user, @current_user) do
                    @controller.update

                    assert_equal 'Documento se ha actualizado con éxito.', @controller.flash[:notice]
                  end
                end
              end
            end
          end
        end
      end
    end
  end

  def test_update_failure
    @documento.stub(:update, false) do
      @controller.stub(:render, nil) do
        @controller.stub(:unprocessable_entity, nil) do
          @controller.instance_variable_set(:@documento, @documento)
          @controller.params = @params
          @controller.stub(:current_user, @current_user) do
            @controller.update

            assert_equal :unprocessable_entity, @controller.response.status
          end
        end
      end
    end
  end
end
@documento = Documento.new(id: 1)
def test_destroy_success
    @documento.stub(:destroy, nil) do
      @controller.stub(:redirect_to, nil) do
        @controller.stub(:notice=, nil) do
          @controller.instance_variable_set(:@documento, @documento)

          @controller.destroy

          assert_equal 'Documento was successfully destroyed.', @controller.flash[:notice]
        end
      end
    end
  end

  def test_destroy_with_associated_payments
    @documento.stub(:destroy, -> { raise ActiveRecord::InvalidForeignKey.new('Cannot delete document because it is associated with payments.') }) do
      @controller.stub(:redirect_to, nil) do
        @controller.stub(:alert=, nil) do
          @controller.stub(:unprocessable_entity, nil) do
            @controller.instance_variable_set(:@documento, @documento)

            @controller.destroy

            assert_equal 'Cannot delete document because it is associated with payments.', @controller.flash[:alert]
          end
        end
      end
    end
  end
  @params = { id: 1 }
  

  def test_set_documento
    Documento.stub(:find, @documento) do
      @controller.stub(:params, @params) do
        @controller.send(:set_documento)

        assert_equal @documento, @controller.instance_variable_get(:@documento)
        assert_equal @documento.id, @controller.instance_variable_get(:@documento_id)
      end
    end
  end
end
