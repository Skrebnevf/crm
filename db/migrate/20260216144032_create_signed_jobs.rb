class CreateSignedJobs < ActiveRecord::Migration[7.1]
  def change
    create_table :signed_jobs do |t|
      t.integer :user_id
      t.string :status
      t.string :additional_expenses
      t.string :incoming_invoice
      t.string :incoming_additional_invoice
      t.string :outcoming_invoice
      t.string :CMR
      t.string :file
      t.string :assign_to_manager
      t.string :assign_to_prosecutor
      t.string :end_of_time_project
      t.timestamps
    end
  end
end
