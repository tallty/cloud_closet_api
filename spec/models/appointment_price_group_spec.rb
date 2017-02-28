require 'rails_helper'

RSpec.describe AppointmentPriceGroup, type: :model do
	it { should belong_to(:appointment) } 
	it { should belong_to(:price_system) } 
  # it { should have_many(:items) } 
end
