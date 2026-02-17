class RenameProsecutorToProcurement < ActiveRecord::Migration[7.1]
  def change
    rename_column :request_for_quatations, :assign_to_prosecutor, :assign_to_procurement
    rename_column :signed_jobs, :assign_to_prosecutor, :assign_to_procurement
  end
end
