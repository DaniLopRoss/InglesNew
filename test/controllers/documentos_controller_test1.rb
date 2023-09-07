require 'minitest/autorun'
require_relative '../../app/controllers/documentos_controller'

class DocumentosControllerTest < ActiveSupport::TestCase
  def setup
    @controller =DocumentosController.new
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
end