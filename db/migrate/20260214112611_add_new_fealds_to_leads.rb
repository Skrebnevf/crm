class AddNewFealdsToLeads < ActiveRecord::Migration[7.1]
  def change
    add_column :leads, :payments_terms, :string
    add_column :leads, :difficulty, :string
    add_column :leads, :country_of_origin, :string
  end
end
