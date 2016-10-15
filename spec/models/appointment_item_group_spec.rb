require 'rails_helper'

RSpec.describe AppointmentItemGroup, type: :model do
  it { should belong_to(:appointment) } 
  it { should have_many(:items) } 
  it { should have_many(:garments).through(:items) } 
end
