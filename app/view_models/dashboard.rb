class Dashboard

  def initialize(user)
    @user = user
  end
  #TODO: Payments by month/year
  #Payments by group (fast food, loan, bank) 
  #Due payments

  def payment_sum_for_user_by_year(year= Date.today.year)
    @user.accounts.map do |account|
      payment_sum = account.payments.where('extract(year from payment_date) = ?', year)
      .group_by_month_of_year(:payment_date, format: "%D").sum(:amount)


      account_data_for(account, payment_sum)
    end
  end

  def payment_sum_for_user_by_month(month = Date.today.month, year = Date.today.year)
    test_account = {}
    @user.accounts.map do |account|
      payment_sum = account.payments
      .where('extract(month from payment_date) = ? and extract(year from payment_date) = ?', month, year)
      .group_by_day_of_month(:payment_date).sum(:amount)

      account_data_for(account, payment_sum)
      
    end
  end

  private
  def account_data_for(account, payment_sum)
    #Get payments amount and reject when sum is 0 so it doesn't include it in graph. (have to check if it can be done within the group_by methods)
    {
      name: account.name, data: exclude_empty(payment_sum)
    }
  end

  def exclude_empty(data)
    data.reject! { |k,v| v == 0 }
  end
end