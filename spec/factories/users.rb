FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    uid { Faker::Lorem.characters(20) }

    reviews { build_list :review, 5, :belongs_to_user }

    factory :user_with_updated_info do
      website_url { "https://zinza.example/" }
    end
  end
end
