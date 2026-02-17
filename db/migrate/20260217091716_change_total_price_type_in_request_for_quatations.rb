class ChangeTotalPriceTypeInRequestForQuatations < ActiveRecord::Migration[7.1]
  def change
    change_column :request_for_quatations, :total_price, :float
  end
end
