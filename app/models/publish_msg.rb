# == Schema Information
#
# Table name: publish_msgs
#
#  id         :integer          not null, primary key
#  title      :string
#  abstract   :string
#  content    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class PublishMsg < ApplicationRecord
	has_one :pubilc_msg_image, -> { where photo_type: "pubilc_msg" }, class_name: "Image", as: :imageable, dependent: :destroy
  accepts_nested_attributes_for :pubilc_msg_image, allow_destroy: true
end
