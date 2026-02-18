class RenamePriceNettoAndTotalPriceInRequestForQuatations < ActiveRecord::Migration[7.1]
  def change
    rename_column :request_for_quatations, :buying_price, :buying
    rename_column :request_for_quatations, :selling_price, :selling
  end
end
