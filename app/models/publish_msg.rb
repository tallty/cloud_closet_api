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
end
