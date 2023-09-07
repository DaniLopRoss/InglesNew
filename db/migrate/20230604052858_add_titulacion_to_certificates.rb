class AddTitulacionToCertificates < ActiveRecord::Migration[7.0]
  def change
    add_column :certificates, :titulacion, :date
  end
end
