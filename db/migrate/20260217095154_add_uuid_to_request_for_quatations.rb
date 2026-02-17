class AddUuidToRequestForQuatations < ActiveRecord::Migration[7.1]
  def change
    add_column :request_for_quatations, :uuid, :string
    add_index :request_for_quatations, :uuid
  end
end
