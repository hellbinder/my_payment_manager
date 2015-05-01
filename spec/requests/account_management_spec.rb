require "spec_helper"

describe "Account management" do
  before { sign_in_as_a_valid_user }
  context "GET: /accounts" do
    it "gets and ok response" do
      get "/accounts"
      # expect(response.code).to eq("302")
      expect(response).to be_ok 
    end
  end

=begin #It's NOT WORKING..hangs in the post. but it's aleready tested in the features
  context "modification" do
    let(:new_account) { FactoryGirl.build :account }
    it "creates an account and redirects to the accounts's path" do
      get new_account_path
      expect(response).to render_template :new

      #post new
      post "/accounts", account: {name: new_account.name, description: new_account.description }
      expect(response).to eq 200

      follow_redirect!
      expect(response).to render_template :show
    end
  end
=end
end