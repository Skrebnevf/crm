class CreateRequestForQuatations < ActiveRecord::Migration[7.1]
  def change
    create_table :request_for_quatations do |t|
      t.string :user_id
      t.string :client
      t.string :from
      t.string :to
      t.string :readiness_date
      t.string :what
      t.string :request_type
      t.string :comment
      t.integer :price_netto
      t.string :payment_terms
      t.string :transit_time
      t.string :preadvise
      t.string :free_time
      t.string :demmurage_rate
      t.string :valid_till
      t.boolean :accepted
      t.boolean :denied
      t.string :reason

      t.timestamps
    end
  end
end
