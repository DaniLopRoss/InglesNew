class AddCommentToPayments < ActiveRecord::Migration[7.0]
  def change
    add_column :payments, :commentp, :string
  end
end
