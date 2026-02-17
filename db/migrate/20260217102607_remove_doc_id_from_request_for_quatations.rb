class RemoveDocIdFromRequestForQuatations < ActiveRecord::Migration[7.1]
  def change
    remove_column :request_for_quatations, :doc_id, :string
  end
end
