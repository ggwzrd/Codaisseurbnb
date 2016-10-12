FactoryGirl.define do
  factory :theme do
    name    { Faker::Lorem.sentence(3, false, 0) }
  end
end
