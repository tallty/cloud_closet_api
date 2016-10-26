require 'rails_helper'

RSpec.describe PurchaseLog, type: :model do
  it { should belong_to(:user_info) } 
end
