# == Schema Information
#
# Table name: user_infos
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  nickname   :string
#  mail       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_user_infos_on_user_id  (user_id)
#

class UserInfo < ApplicationRecord
  belongs_to :user

  delegate :phone, to: :user

  has_one :avatar, -> { where photo_type: "avatar" }, class_name: "Image", as: :imageable, dependent: :destroy
  accepts_nested_attributes_for :avatar, allow_destroy: true
end
