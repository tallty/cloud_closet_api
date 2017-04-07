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

FactoryGirl.define do
  factory :user_msg do
    title "我是标题"
    abstract "我是简述"
    url "我是链接"
    
  end
end
