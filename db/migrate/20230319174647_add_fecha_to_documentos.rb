class AddFechaToDocumentos < ActiveRecord::Migration[7.0]
  def change
    add_column :documentos, :fecha, :date
    add_column :documentos, :status, :string
  end
end
