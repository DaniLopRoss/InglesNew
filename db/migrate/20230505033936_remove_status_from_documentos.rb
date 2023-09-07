class RemoveStatusFromDocumentos < ActiveRecord::Migration[7.0]
  def change
    remove_column :documentos, :status
  end
end
