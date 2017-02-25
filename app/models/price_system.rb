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

class PriceSystem < ApplicationRecord
	has_one :icon_image, -> { where photo_type: "icon" }, class_name: "Image", as: :imageable, dependent: :destroy
  accepts_nested_attributes_for :icon_image, allow_destroy: true

  enum item_type: {
		chest: 0,
		other: 1
	}
end
