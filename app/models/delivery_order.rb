# == Schema Information
#
# Table name: delivery_orders
#
#  id              :integer          not null, primary key
#  address         :string
#  name            :string
#  phone           :string
#  delivery_time   :date
#  delivery_method :string
#  remark          :string
#  delivery_cost   :integer
#  service_cost    :integer
#  aasm_state      :string
#  garment_ids     :string
#  user_id         :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_delivery_orders_on_user_id  (user_id)
#

class DeliveryOrder < ApplicationRecord
  belongs_to :user
  # 只有当配送订单支付(after_pay)之后 Garment 才与 DeliveryOrder 关联
  # 所以允许 garment 的 id 同时存在于多个 delivery_order
  has_many :garments

  validates_presence_of :address, :name, :phone, 
    :delivery_time, :delivery_method, 
    :remark, :delivery_cost, :service_cost,
    :garment_ids, :user_id

  validate :check_garment_ids, on: :create

  include AASM

  aasm do 
  	state :unpaid, initial: true
  	state :paid, :canceled, :delivering, :finished

    event :pay do
      transitions from: :unpaid, to: :paid, after:  :after_pay
    end

    event :cancel do
      transitions from: :unpaid, to: :canceled
    end

    event :admin_send_it_out do
      transitions from: :paid, to: :delivering
    end

    event :user_got_it do
      transitions from: :delivering, to: :finished
    end
	end

  def state
    I18n.t :"delivery_order.#{aasm_state}"
  end

  def amount
    delivery_cost + service_cost
  end

  def garment_ids
    self.[](:garment_ids)&.split(',')
  end

  def garment_ids= value
    raise 'garment_ids input must be an Array' unless value.is_a?(Array)
    self.[]=(:garment_ids, value.join(',')) 
  end

  def its_garments
    garments || self.user.garments.where(id: garment_ids)
  end

  def can_be_paid
    self.user.garments.where(id: garment_ids).
      where.not(status: ['stored', 'in_basket']).any?.!
  end

  private
    def after_pay
      # 此处未改变为 paid
      # 改变衣服状态
      # 此时 如果选择了错误状态的衣服会此处报错
      DeliveryService.new(user).change_garments_status(
        { garment_ids: self.garment_ids }, 
        ['stored', 'in_basket'], 'delivering',
        self
      )
      # 生成交易记录 purchase_log 并扣费
      PurchaseLogService.new(self.user, ['delivery_order'], 
        delivery_order: self
      )
    end

    def check_garment_ids
      garments = self.user.garments.where(id: self.garment_ids)
      errors.add(:garment_ids, "存在无效的 garment_id") if 
        # if there be any garments do not belong to current_user 
        garments.count != self.garment_ids.count || 
        # if there be any garments could not be delivered 
        garments.where.not(status: ['stored', 'in_basket']).any?
    end
  
end
