FactoryBot.define do
  factory :request_for_quatation do
    user { create(:user) }
    author { create(:user) }
    client { FFaker::Company.name }
    from { "LV" }
    to { "TR" }
    readiness_date { "2026-03-01" }
    what { "FTL" }
    request_type { "Spot" }
    comment { "Test comment" }
    buying { 1000 }
    payment_terms { "30 days" }
    accepted { false }
    denied { false }
  end
end
