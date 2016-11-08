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
#  seq         :string
#  row         :integer
#  carbit      :integer
#  place       :integer
#
# Indexes
#
#  index_garments_on_seq      (seq)
#  index_garments_on_user_id  (user_id)
#

FactoryGirl.define do
  factory :garment do
    title "garment title"
    put_in_time "2016-09-23 14:39:08"
    expire_time "2017-09-24 14:39:08"
    association :cover_image, factory: :image, photo_type: "cover"
    row 8
    carbit 7
    place 6
  end
end
