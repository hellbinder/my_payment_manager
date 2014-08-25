# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :note do
    sequence(:title)  { |n| "Some Title #{n}" }
    sequence(:details) { |n| "some detail##{n} for I am a test"} 
  end
end
