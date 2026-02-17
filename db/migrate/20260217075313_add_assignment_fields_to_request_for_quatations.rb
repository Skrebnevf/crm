class AddAssignmentFieldsToRequestForQuatations < ActiveRecord::Migration[7.1]
  def change
    add_column :request_for_quatations, :assign_to_prosecutor, :integer
    add_column :request_for_quatations, :assign_to_sales, :integer
  end
end
