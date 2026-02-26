# frozen_string_literal: true

class Test < ActiveRecord::Base
  validates :title, presence: true
  validates :body, presence: true, length: { minimum: 10 }
  validates :question, inclusion: { in: ["Yes", "Yes, of course"] }

  QUESTIONANSWER = [
    ["Yes", "Yes"],
    ["No", "Yes, of course"]
  ]
end
