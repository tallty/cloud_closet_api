# == Schema Information
#
# Table name: constant_tags
#
#  id         :integer          not null, primary key
#  title      :string(191)
#  class_type :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ConstantTag < ApplicationRecord
	enum class_type: {
		garment: 1
	}
	validates :title, uniqueness: { scope: :class_type }
	scope :class_is, ->(class_name){
		where(class_type: class_name || 'garment')
	}
	

	def self.tag_validate class_name, params
		return params unless params
		p ary = ConstantTag.class_is(class_name).collect(&:title)
		params.split(',').map do |tag| 
			raise "\"#{tag}\"不是合法的标签值" unless tag.in?(ary)
			tag
		end
	end
end

