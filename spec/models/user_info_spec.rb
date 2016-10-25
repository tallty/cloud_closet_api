require 'rails_helper'

RSpec.describe UserInfo, type: :model do
  it { should belong_to(:user) } 
  it { should have_one(:avatar) } 
  it { should have_many(:addresses) } 
end
