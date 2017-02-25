# == Schema Information
#
# Table name: appointment_item_groups
#
#  id              :integer          not null, primary key
#  appointment_id  :integer
#  store_month     :integer
#  price           :float
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  type_name       :string
#  price_system_id :integer
#  chest_id        :integer
#  is_chest        :boolean
#  count_info      :string
#
# Indexes
#
#  index_appointment_item_groups_on_appointment_id   (appointment_id)
#  index_appointment_item_groups_on_chest_id         (chest_id)
#  index_appointment_item_groups_on_price_system_id  (price_system_id)
#

class AppointmentItemGroup < ApplicationRecord
  # table_name -> 价格系统title
  belongs_to :appointment
  belongs_to :price_system
  belongs_to :chest

  has_many :items, class_name: "AppointmentItem", dependent: :destroy
  has_many :garments, through: :items

  validate :check_price_system
  validate :check_count
  before_create :create_relate_chest

  def create_item
    count.times do
      item = self.items.build(
        store_month: self.store_month,
        appointment: self.appointment
        )
      item.save!
    end
  end

  private
    def check_price_system
      errors.add(:price_system_id, 'price_system_id 错误') if self.price_system.nil? 
    end

    def check_count
      # price_system 存在？
      errors.add(:count, '数量错误') if self.count > self.price_system.max_count || self.count < 1
    end

    def create_relate_chest
      _user = self.appointment.try(:user)
      _chest = _user.chests.build(price_system_id: group.price_system_id, last_time_inc_by_month: group.store_month) if _user && self.price_system.try(:item_type) == 'chest'
      raise "衣橱创建失败" unless _chest.save && self.chest = _chest 
    end
end
