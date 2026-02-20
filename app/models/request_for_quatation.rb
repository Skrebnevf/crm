# frozen_string_literal: true

class RequestForQuatation < ActiveRecord::Base
  belongs_to :user
  belongs_to :author, class_name: 'User', optional: true
  has_many :signed_jobs, dependent: :nullify
  scope :my, ->(_user) { all }
  scope :text_search, ->(query) { ransack('client_or_from_or_to_or_comment_cont' => query).result }

  scope :state, lambda { |filters|
    conditions = []
    conditions << 'accepted = true' if filters.include?('accepted')
    conditions << 'denied = true' if filters.include?('denied')
    conditions << '(accepted IS NOT TRUE AND denied IS NOT TRUE)' if filters.include?('rfq_new')

    if conditions.any?
      where(conditions.join(' OR '))
    else
      none
    end
  }
  validates :client, presence: true

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

  def locked?
    accepted? || denied?
  end

  sortable by: ["created_at DESC", "updated_at DESC"], default: "created_at DESC"

  private

  def generate_uuid
    self.uuid = SecureRandom.uuid if uuid.blank?
  end

  def create_signed_job_if_accepted
    return unless accepted?

    with_lock do
      return if signed_jobs.any?

      SignedJob.create!(
        request_for_quatation_id: id,
        user_id: user_id
      )
    end
  end

  def create_signed_job_on_becoming_accepted
    return unless saved_change_to_accepted?
    return unless accepted?

    with_lock do
      return if signed_jobs.any?

      SignedJob.create!(
        request_for_quatation_id: id,
        user_id: user_id
      )
    end
  end
end
