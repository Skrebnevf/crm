class AddRequestForQuatationToSignedJobs < ActiveRecord::Migration[7.1]
  def change
    add_column :signed_jobs, :request_for_quatation_id, :integer
    add_index :signed_jobs, :request_for_quatation_id
  end
end
