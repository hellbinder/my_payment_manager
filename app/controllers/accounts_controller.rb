class AccountsController < ApplicationController
  before_filter :authenticate_user!
  def index
    @accounts = Account.all
  end
  
  def show
    @account = Account.find(params[:id])
    render
  end

  def new
    @account = Account.new
  end

  def update
    
  end

def create
  @account = Account.new(account_params)
  
  respond_to do |format|
    if @account.save
      format.html { redirect_to(@account, notice: "Account was successfully created") }
      format.xml { render xml: @account, status: :created, location: @account }
    else
      format.html { 
        flash[:error] = "There was an error creating the account"
        render action: "new"
      }
      format.xml { render xml: @account.errors, status: :unprocessable_entity }
    end
  end
end

  private
  def account_params
    params.require(:account).permit(:name, :description, :homepage)
  end
end
