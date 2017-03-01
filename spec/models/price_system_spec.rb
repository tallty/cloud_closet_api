# == Schema Information
#
# Table name: price_systems
#
#  id          :integer          not null, primary key
#  price       :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  title       :string
#  is_chest    :boolean
#  description :text
#  unit_name   :string
#

require 'rails_helper'

RSpec.describe PriceSystem, type: :model do
  it { should have_one(:price_icon_image) } 
  it { should have_many(:exhibition_units) } 
end
