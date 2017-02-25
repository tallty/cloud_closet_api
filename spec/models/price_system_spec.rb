# == Schema Information
#
# Table name: price_systems
#
#  id            :integer          not null, primary key
#  price         :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  item_type     :integer
#  max_count_per :integer
#  title         :string
#

require 'rails_helper'

RSpec.describe PriceSystem, type: :model do
  it { should have_one(:icon_image) } 
end
