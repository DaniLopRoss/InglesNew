class AddDocumentoIdToPayments < ActiveRecord::Migration[7.0]
  def change
    add_reference :payments, :documento, null: false, foreign_key: true
  end
end
