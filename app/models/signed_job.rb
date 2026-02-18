require 'fileutils'

class SignedJob < ActiveRecord::Base
  after_initialize :build_default_additional_expense
  belongs_to :request_for_quatation, optional: true
  belongs_to :user, optional: true
  has_many :additional_expenses, dependent: :destroy
  accepts_nested_attributes_for :additional_expenses, allow_destroy: true, reject_if: :all_blank

  scope :text_search, ->(query) {
    q = "%#{query}%"
    joins(:request_for_quatation)
      .where("signed_jobs.doc_id LIKE :q OR signed_jobs.status LIKE :q OR request_for_quatations.client LIKE :q", q: q)
  }

  validate :additional_expenses_count_within_limit

  validates :status,                       presence: true, on: :update, unless: :completed?
  validates :CMR,                          presence: true, on: :update, unless: :completed?
  validates :incoming_invoice,             presence: true, on: :update, unless: :completed?
  validates :incoming_additional_invoice,  presence: true, on: :update, unless: :completed?
  validates :outcoming_invoice,            presence: true, on: :update, unless: :completed?

  before_create :generate_uuid, :generate_doc_id
  before_save :auto_complete_status

  def additional_expenses_count_within_limit
    if additional_expenses.reject(&:marked_for_destruction?).size > 20
      errors.add(:base, "Maximum 20 additional expenses allowed")
    end
  end

  def self.per_page
    20
  end

  attr_reader :uploaded_file

  validate :validate_file_format
  validate :validate_file_size

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

  def completed?
    end_of_time_project.present?
  end

  def additional_buying_total
    rfq_base = request_for_quatation&.buying || 0
    expenses_total = additional_expenses.sum { |e| (e.qty_incoming || 0) * (e.incoming_price || 0) }
    rfq_base + expenses_total
  end

  def additional_selling_total
    rfq_base = request_for_quatation&.selling || 0
    expenses_total = additional_expenses.sum { |e| (e.qty_outcoming || 0) * (e.outcoming_price || 0) }
    rfq_base + expenses_total
  end

  private

  def auto_complete_status
    self.status = 'completed' if end_of_time_project.present?
  end

  def build_default_additional_expense
    additional_expenses.build(label: "Additional Expenses") if additional_expenses.empty?
  end

  def validate_file_format
    return unless @uploaded_file

    extension = File.extname(@uploaded_file.original_filename).downcase
    unless %w[.pdf .doc .docx .jpg .jpeg .txt].include?(extension)
      errors.add(:file, "must be one of: pdf, doc, docx, jpg, jpeg, txt")
    end
  end

  def validate_file_size
    return unless @uploaded_file

    if @uploaded_file.size > 10.megabytes
      errors.add(:file, "size must be less than 10MB")
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
