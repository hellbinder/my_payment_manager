class Dashboard

  def initialize(user)
    @user = user
  end
  #TODO: Payments by month/year
  #Payments by group (fast food, loan, bank) 
  #Due payments
  def payment_sum_for_user_by_year
    @user.accounts.map do |account|
      # account_sum = account.payments.group_by_month(:payment_date, format: "%F").sum(:amount)
      { 
        name: account.name, data: account.payments
        .group_by_month_of_year(:payment_date, format: "%B").sum(:amount) 
        # .where('extract(year from payment_date) = ?', Time.now.year)
      }
    end
  end

  def payment_sum_for_user_by_month
    @user.accounts.map do |account|
      { 
        name: account.name, data: account.payments
        .group_by_day_of_month(:payment_date).sum(:amount)
      }
    end
  end
end