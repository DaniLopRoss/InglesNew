class CreatePayments < ActiveRecord::Migration[7.0]
  def change
    create_table :payments do |t|
      t.string :nombre
      t.string :status
      t.timestamps
    end
  end
end
