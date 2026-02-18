require 'fileutils'

class SignedJob < ActiveRecord::Base
  belongs_to :request_for_quatation, optional: true
  belongs_to :user, optional: true
  before_create :generate_uuid, :generate_doc_id

  def self.per_page
    20
  end

  attr_reader :uploaded_file

  validate :validate_file_format

  def file=(value)
    if value.is_a?(ActionDispatch::Http::UploadedFile)
      @uploaded_file = value
      self[:file] = value.original_filename
    else
      self[:file] = value
    end
  end

  after_save :handle_file_upload

  def generate_uuid
    self.uuid = SecureRandom.uuid if uuid.blank?
  end

  def generate_doc_id
    return if doc_id.present?
    return unless request_for_quatation&.accepted?

    if request_for_quatation
      payment_to_code = request_for_quatation.outcome_payment_from || 'XX'
      payment_from_code = request_for_quatation.income_payment_to || 'XX'
    else
      payment_from_code = 'XX'
      payment_to_code = 'XX'
    end

    year_code = Time.current.year.to_s.last(2)
    sequence_number = (SignedJob.maximum(:id) || 0) + 1
    sequence_str = sequence_number.to_s.rjust(3, '0')

    self.doc_id = "#{payment_from_code}#{payment_to_code}#{year_code}#{sequence_str}"
  end

  private

  def validate_file_format
    return unless @uploaded_file
    extension = File.extname(@uploaded_file.original_filename).downcase
    unless %w[.pdf .doc .docx .jpg .jpeg .txt].include?(extension)
      errors.add(:file, "must be one of: pdf, doc, docx, jpg, jpeg, txt")
    end
  end

  def handle_file_upload
    return unless @uploaded_file && doc_id.present?

    filename = @uploaded_file.original_filename
    relative_path = "files/#{doc_id}/#{filename}"
    directory = Rails.root.join('public', 'files', doc_id.to_s)
    FileUtils.mkdir_p(directory) unless Dir.exist?(directory)

    File.open(directory.join(filename), 'wb') do |file|
      file.write(@uploaded_file.read)
    end

    update_column(:file, relative_path)
  end

end
