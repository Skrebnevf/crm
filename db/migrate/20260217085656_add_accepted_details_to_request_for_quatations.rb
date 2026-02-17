class AddAcceptedDetailsToRequestForQuatations < ActiveRecord::Migration[7.1]
  def change
    add_column :request_for_quatations, :total_price, :string
    add_column :request_for_quatations, :income_payment_to, :string
    add_column :request_for_quatations, :outcome_payment_from, :string
  end
end
