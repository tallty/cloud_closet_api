require 'rails_helper'

RSpec.describe Appointment, type: :model do
  it { should belong_to(:user) } 
  it { should have_many(:items) } 
end
