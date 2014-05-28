class AccountsController < ApplicationController
  before_filter :authenticate_user!
  def index
    @accounts = Account.all
  end
  
  def show
    @account = Account.find(params[:id])
  end
  def account_params
    params.require(:account).permit(:name, :description)
  end
end
