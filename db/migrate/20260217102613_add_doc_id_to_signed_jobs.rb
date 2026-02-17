class AddDocIdToSignedJobs < ActiveRecord::Migration[7.1]
  def change
    add_column :signed_jobs, :doc_id, :string
    add_index :signed_jobs, :doc_id
  end
end
