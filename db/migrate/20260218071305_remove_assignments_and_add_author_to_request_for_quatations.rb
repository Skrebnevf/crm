class RemoveAssignmentsAndAddAuthorToRequestForQuatations < ActiveRecord::Migration[7.1]
  def change
    remove_column :request_for_quatations, :assign_to_procurement, :integer
    remove_column :request_for_quatations, :assign_to_sales, :integer
    add_column :request_for_quatations, :author_id, :integer
  end
end
