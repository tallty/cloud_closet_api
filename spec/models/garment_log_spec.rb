require 'rails_helper'

RSpec.describe GarmentLog, type: :model do
  it { should belong_to(:garment) } 
end
