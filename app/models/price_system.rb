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
	has_one :icon_image, -> { where photo_type: "icon" }, class_name: "Image", as: :imageable, dependent: :destroy
  accepts_nested_attributes_for :icon_image, allow_destroy: true

  validate :check_max_count_info
  # max_count_info is_chest:true -> "挂@*@20@:@叠@*@60"
  # max_count_info is_chest:false -> "10"
	def decode_max_count_info
		# 缺失数据格式验证？
		self.is_chest ?
			self.max_count_info.split('@;@').split('@*@').map { |store_mode, count| {store_mode => count} } :
			self.max_count_info.to_i
	end

  class ChestPrice
  	default_scope {where(is_chest: true)}
  end

  class OtherPrice
  	default_scope {where(is_chest: false)}
  end

  private
  	def check_max_count_info
  		# self.is_chest ?
  		# 	errors.add(:max_count_info, "") :
  	end
end
