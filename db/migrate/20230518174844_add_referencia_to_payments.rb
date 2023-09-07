class AddReferenciaToPayments < ActiveRecord::Migration[7.0]
  def change
    add_column :payments, :referencia, :string
  end
end
