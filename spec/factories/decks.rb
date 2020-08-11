FactoryBot.define do

  factory :deck do
    user

    name { Faker::Restaurant.unique.name }
  end

end