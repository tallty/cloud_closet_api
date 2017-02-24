# == Schema Information
#
# Table name: chest_items
#
#  id              :integer          not null, primary key
#  price_system_id :integer
#  chest_id        :integer
#  garment_id      :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_chest_items_on_chest_id         (chest_id)
#  index_chest_items_on_garment_id       (garment_id)
#  index_chest_items_on_price_system_id  (price_system_id)
#

class ChestItem < ApplicationRecord
  belongs_to :price_system
  belongs_to :chest
  belongs_to :garment

  # 在对应衣橱显示未上架占位
  def is_storing
  	self.garment.storing?
  end
end
