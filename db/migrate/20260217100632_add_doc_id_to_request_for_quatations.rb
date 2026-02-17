class AddDocIdToRequestForQuatations < ActiveRecord::Migration[7.1]
  def change
    add_column :request_for_quatations, :doc_id, :string
    add_index :request_for_quatations, :doc_id
  end
end
