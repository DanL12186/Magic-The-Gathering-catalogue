FactoryBot.define do

  factory :collection do
    user
    
    name { Faker::Name.name }
  end

end