# == Schema Information
#
# Table name: appointment_price_groups
#
#  id              :integer          not null, primary key
#  price_system_id :integer
#  appointment_id  :integer
#  count           :integer
#  store_month     :integer
#  unit_price      :float
#  price           :float
#  is_chest        :boolean
#  title           :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_appointment_price_groups_on_appointment_id   (appointment_id)
#  index_appointment_price_groups_on_price_system_id  (price_system_id)
#

class AppointmentPriceGroup < ApplicationRecord
  belongs_to :price_system
  belongs_to :appointment

  has_many :valuation_chests
  has_many :exhibition_chests, through: :valuation_chests

  validates :count, presence: true

  before_create :restore_price_system_info
  before_create :set_price

  scope :chests, ->{ where( is_chest: true )}
  scope :other_items, ->{ where( is_chest: false )}

  def create_relate_valuation_chest
    return nil unless self.is_chest
    raise '用户错误' unless _user = self.appointment.try(:user)
    count.times do 
      valuation_chests.create!(
          price_system: self.price_system,
          user: _user
      ) rescue ( raise '用户计价柜(valuation_chest)创建失败' )
    end
  end

  private
  	def restore_price_system_info
  		raise 'price_system_id 缺失或错误' unless self.price_system
  		self.unit_price = self.price_system.price
  		self.is_chest = self.price_system.is_chest
      self.title = self.price_system.title
      self.store_month = nil unless self.is_chest
  	end

  	def set_price
  		self.price = (unit_price * count * ( store_month || 1 )).round(2)
  	end

  	
  end
