class AccountsController < ApplicationController
  before_filter :authenticate_user!
  # before_filter :get_account, only: [:show, :edit, :update ]  DONT LIKE TO DO THIS OFTEN. Can get confusing having to go back up to check.

  def index
    @accounts = current_user.accounts
  end
  
  def show
    get_account
    authorize_view
    # render :unauthorized unless current_user.can_delete? @account
  end

  def new
    @account = Account.new
  end

  def create
    @account = Account.new(account_params)
    
    respond_to do |format|
      if @account.save
        @account.add_owner(current_user)
        format.html { redirect_to(@account, notice: "Account was successfully created") }
        format.xml { render xml: @account, status: :created, location: @account }
      else
        format.html { 
          render 'new'
        }
        format.xml { render xml: @account.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    get_account
    authorize_edit
  end

  def update
    get_account
    # getting account in before_filter
    respond_to do |format|
      if @account.update_attributes(account_params)
        format.html { redirect_to(account_path(@account), notice: "Account was successfully updated") }
        format.xml { render xml: @account, status: :updated, location: Account }
      else
        format.html { 
          render 'edit'
          puts "THE ACCOUNT IS #{@account}"

        }
        format.xml { render xml: @account.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @account = Account.destroy(params[:id])
    respond_to do |format|
      format.html { redirect_to accounts_path, notice: "The account was deleted successfully" }
      format.js
    end
  end

private
  def account_params
    params.require(:account).permit(:name, :description, :homepage, :schedule, :payment_amount)
  end

  def get_account
    @account = Account.find(params[:id])
  end

  def authorize_view
    unless current_user.can_view? @account
      flash[:danger] = "You are not authorized to view this account"
      redirect_to(accounts_path) 
    end
  end

  def authorize_edit
    unless current_user.can_modify? @account
      flash[:danger] = "You are not authorized to edit this account"
      redirect_to(accounts_path) 
    end
  end
end
