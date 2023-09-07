class AddStatusToCertificates < ActiveRecord::Migration[7.0]
  def change
    add_column :certificates, :status, :boolean
  end
end
