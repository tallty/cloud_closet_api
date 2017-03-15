# == Schema Information
#
# Table name: garments
#
#  id                  :integer          not null, primary key
#  user_id             :integer
#  title               :string
#  put_in_time         :datetime
#  expire_time         :datetime
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  seq                 :string
#  row                 :integer
#  carbit              :integer
#  place               :integer
#  aasm_state          :string           default("storing")
#  status              :string
#  store_method        :string
#  appointment_id      :integer
#  exhibition_chest_id :integer
#  description         :text
#
# Indexes
#
#  index_garments_on_appointment_id       (appointment_id)
#  index_garments_on_exhibition_chest_id  (exhibition_chest_id)
#  index_garments_on_seq                  (seq)
#  index_garments_on_user_id              (user_id)
#

FactoryGirl.define do
  factory :garment do
    title "garment title"

    association :cover_image, factory: :image, photo_type: "cover"
    association :detail_image_1, factory: :image, photo_type: "detail_1"
    row 8
    carbit 7
    place 6
    description '我是介绍'
  end
end
