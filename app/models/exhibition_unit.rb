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
  
  # 根据 StoreMethod 实例对象创建枚举值
  enum store_method: eval("{#{StoreMethod.all.map{|i| "#{i.title}: #{i.id}"}.join(",\n")}}")
end
