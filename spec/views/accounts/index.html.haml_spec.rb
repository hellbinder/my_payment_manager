require 'spec_helper'

describe "accounts/index.html.haml" do
  before{ Account.create(name: "UAS Echo", description: "UAS Echo Account",  homepage: "http://www.yahoo.com") }
  it "displays the accounts correctly" do
    assign(:accounts,  Account.all)

    render
    expect(rendered).to match /UAS Echo/
    expect(rendered).to match /UAS Echo Account/
    expect(rendered).to match /http:\/\/www.yahoo.com/
  end
end
