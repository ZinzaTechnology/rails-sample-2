FactoryBot.define do
  factory :admin do
    email { Faker::Internet.email }
    password { Faker::Lorem.characters(8) }

    factory :admin_with_updated_info do
      email { "admin@example.com" }
      password { "12345678" }
    end
  end
end
