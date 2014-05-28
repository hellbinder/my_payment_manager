module Helper
  def sign_in(user)
    user.confirm! #NEED THIS IF USING CONFIRMABLE FEATURE IN DEVISE!
    visit new_user_session_path
    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: user.password
    click_on 'Log in'
    # Sign in when not using Capybara as well.
    #cookies[:remember_token] = user.remember_token
  end
end