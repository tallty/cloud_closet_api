require 'rails_helper'

RSpec.describe Distribution, type: :model do
  it { should have_many(:items) } 
end
