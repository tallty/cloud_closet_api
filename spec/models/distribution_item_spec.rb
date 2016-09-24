require 'rails_helper'

RSpec.describe DistributionItem, type: :model do
  it { should belong_to(:garment) } 
  it { should belong_to(:distribution) } 
end
