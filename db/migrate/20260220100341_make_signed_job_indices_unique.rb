class MakeSignedJobIndicesUnique < ActiveRecord::Migration[7.1]
  def change
    # 1. Make RFQ_id unique in SignedJobs to prevent multiple jobs for one RFQ
    remove_index :signed_jobs, :request_for_quatation_id
    add_index :signed_jobs, :request_for_quatation_id, unique: true

    # 2. Make UUIDs unique as a safety measure for both models
    remove_index :signed_jobs, :uuid if index_exists?(:signed_jobs, :uuid)
    add_index :signed_jobs, :uuid, unique: true

    remove_index :request_for_quatations, :uuid if index_exists?(:request_for_quatations, :uuid)
    add_index :request_for_quatations, :uuid, unique: true
  end
end
