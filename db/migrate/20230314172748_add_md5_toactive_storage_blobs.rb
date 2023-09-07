class AddMd5ToactiveStorageBlobs < ActiveRecord::Migration[7.0]
  def change
    add_column :active_storage_blobs, :md5, :string 
  end
end
