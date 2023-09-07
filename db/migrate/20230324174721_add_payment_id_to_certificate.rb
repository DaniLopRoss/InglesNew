class AddPaymentIdToCertificate < ActiveRecord::Migration[7.0]
  def change
    add_reference :certificates, :payment, null: false, foreign_key: true
  end
end
