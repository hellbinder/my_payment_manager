class PaymentsController < ApplicationController
  def new
    if @account
      @payment = @account.payments.build
    else
      @payment = Payment.new
      @account = nil
    end
    
  end

  def create
    #Make new params and modify the date so it is accepted by rails database. (Getting argument our of range error with bootstrap datepicker)
    new_payment_params = payment_params
    new_payment_params[:payment_date] = Date.strptime(new_payment_params[:payment_date], "%m/%d/%Y").strftime("%Y-%m-%d")
    @payment = Payment.new(new_payment_params)
    @payment.paid = true
    respond_to do |format|
      if @payment.save
        format.html { redirect_to(account_path(params[:payment][:account_id]), notice: "Payment was successfully created") }
        format.xml { render xml: @payment, status: :created, location: @payment }
      else
        format.html { 
          flash[:error] = "There was an error creating the payment"
          render action: "new"
          # redirect_to new_payment_path
        }
        format.xml { render xml: @payment.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @account = Account.find(params[:account_id])
    @payment = Payment.find(params[:id])
  end

  def update
    #Make new params and modify the date so it is accepted by rails database. (Getting argument our of range error with bootstrap datepicker)
    new_payment_params = payment_params
    new_payment_params[:payment_date] = Date.strptime(new_payment_params[:payment_date], "%m/%d/%Y").strftime("%Y-%m-%d")
    @payment = Payment.find(params[:id])
    respond_to do |format|
      if @payment.update_attributes(new_payment_params)
        format.html { redirect_to(account_path(params[:payment][:account_id]), notice: "Payment was successfully updated") }
        format.xml { render xml: @payment, status: :created, location: @payment }
      else
        format.html { 
          flash[:error] = "There was an error updating the payment"
          render action: "edit"
          # redirect_to new_payment_path
        }
        format.xml { render xml: @payment.errors, status: :unprocessable_entity }
      end
    end
  end


  private
    def payment_params
      params.require(:payment).permit(:account_id, :payment_date, :amount, :paid) #Don't foget to add the related table field (account_id)
    end
end
