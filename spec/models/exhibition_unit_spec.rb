# == Schema Information
#
# Table name: exhibition_units
#
#  id              :integer          not null, primary key
#  title           :string
#  store_method    :integer
#  max_count       :integer
#  need_join       :boolean
#  price_system_id :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_exhibition_units_on_price_system_id  (price_system_id)
#

require 'rails_helper'

RSpec.describe ExhibitionUnit, type: :model do
	it { should belong_to(:price_system) }
	it { should have_one(:exhibition_icon_image) }
	it { should have_many(:exhibition_chests) }
end
