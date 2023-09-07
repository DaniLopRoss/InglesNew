class AddUserUpdateRefToDocumentos < ActiveRecord::Migration[7.0]
  def change
    add_reference :documentos, :user_update, foreign_key: { to_table: :users }
  end
end
