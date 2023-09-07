class AddStatusToDocumentos < ActiveRecord::Migration[7.0]
  def change
    add_column :documentos, :status, :boolean
  end
end
