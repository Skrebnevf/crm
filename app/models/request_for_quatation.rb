class RequestForQuatation < ActiveRecord::Base
  belongs_to :user
  scope :my, ->(user) { where(user_id: user.id) }

  acts_as_commentable
  uses_comment_extensions
  acts_as_taggable_on :tags
  has_paper_trail versions: { class_name: 'Version' }, ignore: [:subscribed_users]
  has_fields
  exportable
  has_many :emails, as: :mediator

  def name
    client
  end

  def self.per_page
    20
  end
  sortable by: ["created_at DESC", "updated_at DESC"], default: "created_at DESC"
end
