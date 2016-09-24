require 'rails_helper'

RSpec.describe Garment, type: :model do
  it { should belong_to(:user) } 
  it { should have_one(:cover_image) } 
end
