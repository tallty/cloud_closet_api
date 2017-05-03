# == Schema Information
#
# Table name: price_systems
#
#  id          :integer          not null, primary key
#  price       :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  title       :string(191)
#  is_chest    :boolean
#  description :text(65535)
#  unit_name   :string(191)
#

class PriceSystem < ApplicationRecord
	has_many :exhibition_units, dependent: :destroy

	has_one :price_icon_image, -> { where photo_type: "price_icon" }, class_name: "Image", as: :imageable, dependent: :destroy
  accepts_nested_attributes_for :price_icon_image, allow_destroy: true

  scope :chests, ->{where(is_chest: true)}
  private
  
end
