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

  RSpec::Matchers.define :have_error_message do |message|
    match do |page|
      expect(page).to have_selector('div.alert.alert-danger', text: message)
    end
  end

  RSpec::Matchers.define :have_success_message do |message|
    match do |page|
      expect(page).to have_selector('div.alert.alert-success', text: message)
    end
  end

  RSpec::Matchers.define :have_notice_message do |message|
    match do |page|
     expect(page).to have_selector('div.alert.alert-notice', text: message)
    end
  end
end