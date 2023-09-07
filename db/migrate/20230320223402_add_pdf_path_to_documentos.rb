class AddPdfPathToDocumentos < ActiveRecord::Migration[7.0]
  def change
    add_column :documentos, :pdf_path, :string
  end
end
