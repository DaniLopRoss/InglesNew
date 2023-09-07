class AddVerificarToPayments < ActiveRecord::Migration[7.0]
  def change
    add_column :payments, :verificar, :boolean
  end
end
