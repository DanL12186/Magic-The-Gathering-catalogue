FactoryBot.define do

  factory :deck do
    user

    name { Faker::Restaurant.name }
  end

end