require 'rails_helper'

RSpec.describe Bill, type: :model do
   it { should belong_to(:user) } 
end
