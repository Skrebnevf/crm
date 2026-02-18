class AdditionalExpense < ActiveRecord::Base
  belongs_to :signed_job

  validates :label, presence: true
  validates :incoming_price, numericality: true
  validates :outcoming_price, numericality: true
  validates :qty_incoming, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :qty_outcoming, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
