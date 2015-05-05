class AccountsUsersController < ApplicationController
  before_filter :find_account, only: [:create ]

  def index
    
  end

  def create
    @user_role = AccountsUser.new(account_user_params)
    respond_to do |format|
      if @result = @user_role.save
        format.html { redirect_to @user_role.account, success: "The user was added to the account" }
        format.js
      else
        format.html do
          flash[:error] = "Error when creating role"
          redirect_to(edit_account_path(@account))
        end
        format.js { }
        # format.html { redirect_to edit_account_path(account_user_params[:account_id]), success: "There was an error saving the role" }
      end
    end
  end
  
  def destroy
    @role = AccountsUser.find(params[:id])
    respond_to do |format| 
      if @result = @role.destroy
          format.html { redirect_to @role.account, notice: "#{@role.user.name} has been removed from the account" }
          format.js {}
      else
          format.js {}
      end
    end
  end

  private
  def find_account
    @account = account_user_params[:account_id] if account_user_params[:account_id]
  end

  def account_user_params
    params.require(:accounts_user).permit(:role, :user_id, :account_id)
  end
end