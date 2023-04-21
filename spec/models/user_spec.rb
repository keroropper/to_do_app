require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { FactoryBot.build(:user) }
  it "Factoryが有効であること" do
    expect(user).to be_valid
  end
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_length_of(:name).is_at_most(10) }
  it { is_expected.to validate_presence_of :email }
  it { is_expected.to validate_uniqueness_of(:email).ignoring_case_sensitivity }
  it 'メールアドレスのフォーマット検証' do
    invalid_address = %w[a@a,com a_a.com a@a. a@a_a.com a@a+a.com]
    invalid_address.each do |address|
      user.email = address
      expect(user).to_not be_valid 
    end
  end
  it { is_expected.to validate_presence_of :password }
  it { is_expected.to validate_length_of(:password).is_at_least(6) }
end
