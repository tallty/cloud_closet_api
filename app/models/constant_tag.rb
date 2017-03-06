# == Schema Information
#
# Table name: constant_tags
#
#  id         :integer          not null, primary key
#  title      :string
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
	
end

