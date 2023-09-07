class AddSerialToDocumentos < ActiveRecord::Migration[7.0]
  def change
    add_column :documentos, :serial, :string
    add_column :documentos, :no_oficio, :string
    add_column :documentos, :asunto, :string
    add_column :documentos, :plan, :string
    add_column :documentos, :nombre, :string
    add_column :documentos, :numero_de_control, :string
    add_column :documentos, :carrera, :string
    add_column :documentos, :nivel, :string
    add_column :documentos, :periodo, :string
    add_column :documentos, :md5, :string
    add_column :documentos, :cadena_comprobacion, :string
  end
end
