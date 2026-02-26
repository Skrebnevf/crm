class CreateTests < ActiveRecord::Migration[7.1]
  def change
    create_table :tests do |t|
      t.string :title
      t.string :body
      t.string :question

      t.timestamps
    end
  end
end
