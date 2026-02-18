FactoryBot.define do
  factory :request_for_quatation do
    user_id { "MyString" }
    client { "MyString" }
    from { "MyString" }
    to { "MyString" }
    readiness_date { "MyString" }
    what { "MyString" }
    request_type { "MyString" }
    comment { "MyString" }
    buying { 1 }
    payment_terms { "MyString" }
    transit_time { "MyString" }
    preadvise { "MyString" }
    free_time { "MyString" }
    demmurage_rate { "MyString" }
    valid_till { "MyString" }
    accepted { false }
    denied { false }
    reason { "MyString" }
  end
end
