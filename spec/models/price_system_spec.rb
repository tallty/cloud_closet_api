# == Schema Information
#
# Table name: price_systems
#
#  id         :integer          not null, primary key
#  name       :string
#  season     :string
#  price      :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe PriceSystem, type: :model do
  it { should have_one(:icon_image) } 
end
