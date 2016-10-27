require 'rails_helper'

RSpec.describe PriceSystem, type: :model do
  it { should have_one(:icon_image) } 
end
