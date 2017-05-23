# == Schema Information
#
# Table name: public_msgs
#
#  id         :integer          not null, primary key
#  title      :string
#  abstract   :string
#  content    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class PublicMsg < ApplicationRecord
	has_one :public_msg_image, -> { where photo_type: "public_msg" }, class_name: "Image", as: :imageable, dependent: :destroy
  accepts_nested_attributes_for :public_msg_image, allow_destroy: true
end
