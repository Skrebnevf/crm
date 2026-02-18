# frozen_string_literal: true

class RequestForQuatation < ActiveRecord::Base
  belongs_to :user
  belongs_to :author, class_name: 'User', optional: true
  has_many :signed_jobs, dependent: :nullify
  scope :my, ->(user) { where(user_id: user.id) }

  acts_as_commentable
  uses_comment_extensions
  acts_as_taggable_on :tags
  has_paper_trail versions: { class_name: 'Version' }, ignore: [:subscribed_users]
  has_fields
  exportable
  has_many :emails, as: :mediator, dependent: :nullify
  before_create :generate_uuid
  after_create :create_signed_job_if_accepted
  after_update :create_signed_job_on_becoming_accepted

  def name
    client
  end

  def self.per_page
    20
  end
  sortable by: ["created_at DESC", "updated_at DESC"], default: "created_at DESC"

  private

  def generate_uuid
    self.uuid = SecureRandom.uuid if uuid.blank?
  end

  def create_signed_job_if_accepted
    return unless accepted?
    return if signed_jobs.any?

    SignedJob.create!(
      request_for_quatation_id: id,
      user_id: user_id
    )
  end

  def create_signed_job_on_becoming_accepted
    return unless saved_change_to_accepted?
    return unless accepted?
    return if signed_jobs.any?

    SignedJob.create!(
      request_for_quatation_id: id,
      user_id: user_id
    )
  end
end
