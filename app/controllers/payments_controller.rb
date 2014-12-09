class PaymentsController < ApplicationController
  before_filter :get_account, only: [:new, :create]

  def new
    if @account
      @payment = @account.payments.build
    else
      @payment = Payment.new
    end
    
  end

  def create
    if @account
      @payment = @account.payments.new(payment_params)
    else
      @payment  = Payment.new(payment_params)
    end
  
    respond_to do |format|
      if @payment.save
        format.html { redirect_to(@account, notice: "Payment was successfully created") }
        format.xml { render xml: @payment, status: :created, location: @payment }
      else
        format.html { 
          flash[:error] = "There was an error creating the payment"
          render action: "new"
        }
        format.xml { render xml: @payment.errors, status: :unprocessable_entity }
      end
    end
  end

  private
  def payment_params
    params.require(:payment).permit(:account_id,:payment_date, :amount) #Don't foget to add the related table field (account_id)
  end

  #this is pretty horrible. Maybe just forget about hiding the dropdown and select it automatically if there is an account associated.
  #would make it easier to mantain.
  def get_account
    if self.action_name == "new"
      @account = Account.find(params[:account_id]) unless params[:account_id].nil?
    elsif self.action_name == "create"
      if params[:account_id].nil?
        @account = Account.find(params[:payment][:account_id]) 
      else
        @account = Account.find(params[:account_id])
      end
    end
  end
end
