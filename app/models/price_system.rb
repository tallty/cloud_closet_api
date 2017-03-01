# == Schema Information
#
# Table name: price_systems
#
#  id         :integer          not null, primary key
#  price      :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  title      :string
#  is_chest   :boolean
#

class PriceSystem < ApplicationRecord
	has_one :price_icon_image, -> { where photo_type: "price_icon" }, class_name: "Image", as: :imageable, dependent: :destroy
  accepts_nested_attributes_for :icon_image, allow_destroy: true

  private
  
end
