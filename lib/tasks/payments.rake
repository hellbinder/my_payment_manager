namespace :payments do
  desc "Check and create payments that are due in the next few days"
  task create_recurring: :environment do
     Account.select {|a| a.converted_schedule != nil}.each do |account|
      account.converted_schedule.occurrences_between(Date.today, Date.today + 3.days).each do |occurrence|
        puts "Creating payment for date #{occurrence} and account #{account.name}"
        account.payments.create(payment_date: occurrence.to_date, amount: account.payment_amount)
      end
    end
  end

end
