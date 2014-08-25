# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :credit_card do
    sequence(:name)  { |n| "Credit Card ##{n}" }
    credit_limit "9.99"
    interest_rate "9.99"
    balance_transfer_fee "9.99"
    no_interest_months 1
    foreign_transaction_fee "9.99"
    homepage "http://www.citi.com"
  end
end
