class AdditionalExpense < ActiveRecord::Base
  belongs_to :signed_job

  validates :label, presence: true
  validates :amount, numericality: true
end
