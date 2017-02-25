# == Schema Information
#
# Table name: price_systems
#
#  id             :integer          not null, primary key
#  price          :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  title          :string
#  max_count_info :string
#  is_chest       :boolean
#

class PriceSystem < ApplicationRecord
	# max_count_info is_chest -> 挂@*@20@:@叠@*@60
	has_one :icon_image, -> { where photo_type: "icon" }, class_name: "Image", as: :imageable, dependent: :destroy
  accepts_nested_attributes_for :icon_image, allow_destroy: true

  class ChestPrice
  	default_scope {where(is_chest: true)}

  	def decode_max_count_info
  		self.max_count_info.
  	end
  end

  class OtherPrice
  	default_scope {where(is_chest: false)}

  	def decode_max_count_info
  		
  	end

  end
end
