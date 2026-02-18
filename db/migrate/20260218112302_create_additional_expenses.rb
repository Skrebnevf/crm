class CreateAdditionalExpenses < ActiveRecord::Migration[7.1]
  def up
    create_table :additional_expenses do |t|
      t.integer :signed_job_id
      t.string :label
      t.decimal :amount, precision: 10, scale: 2, default: 0.0

      t.timestamps
    end
    add_index :additional_expenses, :signed_job_id

    # Data migration: Move existing additional_expenses to the new table
    SignedJob.reset_column_information
    SignedJob.find_each do |job|
      if job.additional_expenses.present?
        AdditionalExpense.create!(
          signed_job_id: job.id,
          label: "Additional Expenses",
          amount: job.additional_expenses.to_f
        )
      end
    end
  end

  def down
    drop_table :additional_expenses
  end
end
