namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    puts "Removing from all tables"
    User.delete_all
    Account.delete_all #Should delete payments because it is dependent
    User.create!(name: "Miguel Martorell",
                 email: "miguel_1216@yahoo.com",
                 password: "admin123",
                 password_confirmation: "admin123",
                 confirmed_at: Time.now)
    accounts = ["Bank Of America", "BestBuy", "Penfed", "Gap", "Citibank", "UAS Echo"]
    homepages = ["http://www.bankofamerica.com", "http://www.bestbuy.com", "http://www.penfed.com", "http://www.gap.com", "http://www.citi.com", "http://www.yahoo.com"]
    6.times do |n|
      puts "Creating account #{accounts[n-1]}"
      recent_account = Account.create!(
      name: accounts[n-1],
      description: "Some descripton for #{accounts[n-1]}",
      homepage: homepages[n-1])
      3.times do |o|
        puts "Creating a new payment for #{accounts[n-1]}"
        Payment.create!(
            account_id: recent_account.id,
            amount: Faker::Number.number(2),
            payment_date: o.months.ago
          )
      end
    end
  end
end