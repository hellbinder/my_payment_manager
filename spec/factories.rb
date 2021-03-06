FactoryGirl.define do
  factory :user do
    #create sequence to have unique users
    sequence(:name)  { |n| "Person #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com"} 
    password "12345678"
    password_confirmation "12345678"
    confirmed_at Time.now
    factory :admin do
      admin true
    end
    factory :non_active_user do
      active false
    end
  end

  factory :payment do
    account_id 1
    sequence(:amount) {|n| 10 * n}
    sequence(:payment_date) { |n| n.days.ago } 
    factory :paid_payment do
      paid true
    end
  end

  factory :account do
    sequence(:name) { |n| "Test Account##{n}" }
    sequence(:description) { |n| "Description for account##{n}" }
    sequence(:homepage) {|n| "http://www.citi.com/#{n}"}
    factory :recurring_account do
      schedule IceCube::Rule.monthly.day_of_month([1,15]).to_hash
      payment_amount 450
    end
  end

  factory :accounts_user do
    account FactoryGirl.create :account
    user User.first
    factory :account_owner do 
      role "owner"
    end
    factory :account_member do 
      role "member"
    end
    factory :account_viewer do 
      role "viewer"
    end
  end
end