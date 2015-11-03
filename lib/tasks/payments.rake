namespace :payments do
  desc "Check and create payments that are due in the next few days"
  task create_recurring: :environment do
     Account.select {|a| a.converted_schedule != nil}.each do |account|
      account.converted_schedule.occurrences_between(Date.today, Date.today + 3.days).each do |occurrence|
        #if there is no automatic payments that already exist for the given day, then create it. This prevents duplication when run daily.
        unless Payment.where(account: account, payment_date: occurrence.to_date, automatic: true).exists?
          puts "Creating payment for date #{occurrence} and account #{account.name}"
          account.payments.create(payment_date: occurrence.to_date, amount: account.payment_amount, automatic: true)
        else
          puts "No payment created for #{occurrence.to_date} because it has already been created"
        end
      end
    end
  end
end
