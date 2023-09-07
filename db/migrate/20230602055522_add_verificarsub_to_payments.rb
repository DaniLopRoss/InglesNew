class AddVerificarsubToPayments < ActiveRecord::Migration[7.0]
  def change
    add_column :payments, :verificarsub, :boolean
  end
end
