class SetDefaultStatusForSignedJobs < ActiveRecord::Migration[7.1]
  def change
    change_column_default :signed_jobs, :status, 'new'

    reversible do |dir|
      dir.up do
        execute "UPDATE signed_jobs SET status = 'new' WHERE status IS NULL OR status = ''"
      end
    end
  end
end
