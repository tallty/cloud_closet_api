require 'rails_helper'

RSpec.describe AppointmentItem, type: :model do
  it { should belong_to(:garment) } 
  it { should belong_to(:appointment) } 
end
