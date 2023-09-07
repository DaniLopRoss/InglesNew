class AddCommentToDocumento < ActiveRecord::Migration[7.0]
  def change
    add_column :documentos, :comment, :string
  end
end
