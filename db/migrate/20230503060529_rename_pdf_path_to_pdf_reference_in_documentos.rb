class RenamePdfPathToPdfReferenceInDocumentos < ActiveRecord::Migration[7.0]
  def change
    rename_column :documentos, :pdf_path, :referencia
  end
end
