class AddUuidToSignedJobs < ActiveRecord::Migration[7.1]
  def change
    add_column :signed_jobs, :uuid, :string
    add_index :signed_jobs, :uuid
  end
end
