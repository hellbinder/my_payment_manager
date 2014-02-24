FactoryGirl.define do
  factory :user do
    #create sequence to have unique users
    sequence(:name)  { |n| "Person #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com"} 
    password "12345678"
    password_confirmation "12345678"
    factory :admin do
      admin true
    end
    factory :non_active_user do
      active false
    end
  end

  factory :account do
    sequence(:name) { |n| "Test Account##{n}" }
  end

  factory :payment do
    payment_date Date.today
  end

end