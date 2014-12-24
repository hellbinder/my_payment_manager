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
    @payment  = Payment.new(payment_params)

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
