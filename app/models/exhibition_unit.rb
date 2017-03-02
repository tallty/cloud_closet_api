# == Schema Information
#
# Table name: exhibition_units
#
#  id              :integer          not null, primary key
#  title           :string
#  store_method    :integer
#  max_count       :integer
#  need_join       :boolean
#  price_system_id :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_exhibition_units_on_price_system_id  (price_system_id)
#

class ExhibitionUnit < ApplicationRecord
  belongs_to :price_system
  has_many :exhibition_chests

  has_one :exhibition_icon_image, -> { where photo_type: "exhibition_icon" }, class_name: "Image", as: :imageable, dependent: :destroy
  accepts_nested_attributes_for :exhibition_icon_image, allow_destroy: true
  
  # 根据 StoreMethod 实例对象创建枚举值
  # hanging 1 , stacking 2, full_derss 3
  enum store_method: eval("{#{ StoreMethod.all.map{ |i| "#{i.title}: #{i.id}" }.join(',')}}")
end
