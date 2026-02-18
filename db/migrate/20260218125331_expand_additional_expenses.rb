class ExpandAdditionalExpenses < ActiveRecord::Migration[7.1]
  def change
    rename_column :additional_expenses, :amount, :incoming_price
    add_column :additional_expenses, :qty_incoming, :integer, default: 1
    add_column :additional_expenses, :outcoming_price, :decimal, precision: 10, scale: 2, default: 0.0
    add_column :additional_expenses, :qty_outcoming, :integer, default: 1
  end
end
