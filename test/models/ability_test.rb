# test/models/ability_test.rb

require "test_helper"

class AbilityTest < ActiveSupport::TestCase
  test "admin can manage all" do
    admin = User.new(role: "administrador")
    ability = Ability.new(admin)

    assert ability.can?(:manage, :all)
  end

  test "ingles can perform cru actions on Documento, except for payment, and can't manage Payment and Certificate" do
    ingles = User.new(role: "ingles")
    ability = Ability.new(ingles)

    assert ability.can?(:create, Documento)
    assert ability.can?(:read, Documento)
    assert ability.can?(:update, Documento)
    assert ability.cannot?(:destroy, Documento)
    assert ability.cannot?(:payment, Documento)

    assert ability.cannot?(:manage, Payment)
    assert ability.cannot?(:manage, Certificate)
  end

  test "financieros can perform cru actions on Payment, except for certificate, and can't manage Documento and Certificate" do
    financieros = User.new(role: "financieros")
    ability = Ability.new(financieros)

    assert ability.can?(:create, Payment)
    assert ability.can?(:read, Payment)
    assert ability.can?(:update, Payment)
    assert ability.cannot?(:destroy, Payment)
    assert ability.cannot?(:certificate, Payment)

    assert ability.cannot?(:manage, Documento)
    assert ability.cannot?(:manage, Certificate)
  end

  test "escolares can read Payment and Documento, except for edit, update, and destroy actions" do
    escolares = User.new(role: "escolares")
    ability = Ability.new(escolares)

    assert ability.can?(:read, Payment)
    assert ability.cannot?(:edit, Payment)
    assert ability.cannot?(:update, Payment)
    assert ability.cannot?(:destroy, Payment)

    assert ability.can?(:read, Documento)
    assert ability.cannot?(:edit, Documento)
    assert ability.cannot?(:update, Documento)
    assert ability.cannot?(:destroy, Documento)
  end

  test "direccion can perform cru actions on Certificate" do
    direccion = User.new(role: "direccion")
    ability = Ability.new(direccion)

    assert ability.can?(:create, Certificate)
    assert ability.can?(:read, Certificate)
    assert ability.can?(:update, Certificate)
    assert ability.cannot?(:destroy, Certificate)
  end
end
