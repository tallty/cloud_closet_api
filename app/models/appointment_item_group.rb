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
  validate :check_count_info
  validate :store_month, presence: true

  after_create :create_relate_chest
  after_create :copy_info_about_price_system

  def create_item
    decode_count_info.each do |store_mode, count|
      count.times do
        item = self.items.build(
          store_month: self.store_month,
          appointment: self.appointment,
          store_mode: store_mode
          )
        item.save!
      end
    end
  end

  def decode_count_info
    is_chest ? count_info.split('@;@').split('@*@') : count_info.to_i
  end

  def total_count
    is_chest ? eval(decode_count_info.map {|store_mode, count| count}.join('+')) : decode_count_info
  end

  private

    def copy_info_about_price_system
      self.is_chest = self.price_system.is_chest
      self.type_name = self.price_system.title
      self.price = self.is_chest ? self.price_system.price : self.price_system.price * self.decode_count_info
    end

    def create_relate_chest
      _user = self.appointment.try(:user)
      _chest = _user.chests.build(price_system: group.price_system, last_time_inc_by_month: group.store_month) if _user && self.price_system.is_chest
      raise "衣橱创建失败" unless _chest.save && self.chest = _chest 
    end

    def check_price_system
      errors.add(:price_system_id, 'price_system_id 错误') if self.price_system.nil? 
    end

    def check_count_info
      _condition = self.price_system.decode_max_count_info
      self.price_system.is_chest ?
        self.decode_count_info.each {|store_mode, count| raise "#{store_mode}数量错误，不应为#{count}" if count < 1 || _condition[store_mode] < count} :
        (raise "必须为正整数" if self.decode_count_info < 1)
    rescue => error
      errors.add(:count_info, error)
    end

    
end

