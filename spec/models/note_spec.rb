require 'spec_helper'

describe Note do
  it "is valid with all attributes filled" do
    expect(FactoryGirl.build :note).to be_valid
  end
  it "is invalid when title is empty" do
    expect(FactoryGirl.build :note, title: nil).to_not be_valid
  end
  it "is invalid when detail is empty" do
    expect(FactoryGirl.build :note, detail: nil).to_not be_valid
  end

  #Associations
  it { is_expected.to belong_to(:noteable) } 
end
