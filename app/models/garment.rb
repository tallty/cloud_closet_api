# == Schema Information
#
# Table name: garments
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  title       :string
#  put_in_time :datetime
#  expire_time :datetime
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_garments_on_user_id  (user_id)
#

class Garment < ApplicationRecord
  belongs_to :user

  has_one :cover_image, -> { where photo_type: "cover" }, class_name: "Image", as: :imageable, dependent: :destroy
  accepts_nested_attributes_for :cover_image, allow_destroy: true

  def is_new
    put_in_time > Time.zone.now - 3.day
  end
  
end