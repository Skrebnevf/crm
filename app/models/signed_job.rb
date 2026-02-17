# frozen_string_literal: true

class SignedJob < ActiveRecord::Base
  belongs_to :request_for_quatation, optional: true
  before_create :generate_uuid, :generate_doc_id

  def generate_uuid
    self.uuid = SecureRandom.uuid if uuid.blank?
  end

  def generate_doc_id
    return if doc_id.present?
    return unless request_for_quatation&.accepted?

    if request_for_quatation
      payment_from_code = request_for_quatation.outcome_payment_from || 'XX'
      payment_to_code = request_for_quatation.income_payment_to || 'XX'
    else
      payment_from_code = 'XX'
      payment_to_code = 'XX'
    end

    year_code = Time.current.year.to_s.last(2)
    sequence_number = (SignedJob.maximum(:id) || 0) + 1
    sequence_str = sequence_number.to_s.rjust(3, '0')

    self.doc_id = "#{payment_from_code}#{payment_to_code}#{year_code}#{sequence_str}"
  end
end
