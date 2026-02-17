# frozen_string_literal: true

FactoryBot.define do
  factory :signed_job do
    status { "pending" }
    additional_expenses { "" }
    incoming_invoice { "" }
    incoming_additional_invoice { "" }
    outcoming_invoice { "" }
    CMR { "" }
    file { "" }
    assign_to_manager { "" }
    assign_to_procurement { "" }
    end_of_time_project { "" }
    uuid { SecureRandom.uuid }

    user
    request_for_quatation

    trait :with_doc_id do
      after(:create) do |signed_job|
        signed_job.generate_doc_id
        signed_job.save
      end
    end
  end
end
