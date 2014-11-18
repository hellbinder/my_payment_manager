class PaymentsController < ApplicationController

  def new
    @account = Account.find(params[:account_id])
    @payment = @account.payments.build
  end

  def create
    @account = Account.find(params[:account_id])
    @payment = @account.payments.new(payment_params)
  
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
end