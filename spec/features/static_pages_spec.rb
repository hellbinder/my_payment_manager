require 'spec_helper'
include ApplicationHelper

describe "Static Pages" do
  subject { page } 

describe "loggin in as a user" do
  let(:user) { FactoryGirl.create :user }
  before { sign_in user }
  it "should have all the necessary links" do
    expect(page).to have_link "Accounts", href: accounts_path
    expect(page).to have_link "About", href: about_path
    expect(page).to have_link "Contact", href: contact_path

  end
  #visible false apparently new in the latest capybara. This since it cant be seen since it's in header.
  it "should have the information on the static pages" do
    visit root_path
    click_link "About"
    expect(page).to have_content "This web site is a self made payment manager application to keep"
    expect(page).to have_title full_title("About Us")
    click_link "Contact"
    expect(page).to have_title full_title("Contact")

    # click_link "Help"
    # page.should have_selector 'title', text: full_title('Help')
    # click_link "Home"
    # click_link "Sign up now!"
    # page.should have_selector 'title', text: full_title('Sign up')
    # click_link "sample app"
    # page.should have_selector 'title', text: full_title('')
  end
end
end
