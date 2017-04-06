# == Schema Information
#
# Table name: user_msgs
#
#  id         :integer          not null, primary key
#  title      :string
#  abstract   :string
#  url        :string
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_user_msgs_on_user_id  (user_id)
#

class UserMsg < ApplicationRecord
	belongs_to :user
	# 除了账单还有其他的消息，例如订单状态变化的消息通知等等，后面还会有会员变更，系统消息。
end
