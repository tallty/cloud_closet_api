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
#  seq             :string
#
# Indexes
#
#  index_delivery_orders_on_user_id  (user_id)
#

class DeliveryOrder < ApplicationRecord
  default_scope { where.not( aasm_state: 'deleted' ).order('created_at DESC') }

  belongs_to :user
  # 只有当配送订单支付(after_pay)之后 Garment 才与 DeliveryOrder 关联
  # 所以允许 garment 的 id 同时存在于多个 delivery_order
  has_many :garments

  validates_presence_of :address, :name, :phone, 
    :delivery_time, :delivery_method,
    :delivery_cost, :service_cost,
    :garment_ids, :user_id

  validate :check_garment_ids, on: :create

  after_create :generate_seq
  after_save :send_wechat_delivery_order_state_msg, if: :aasm_state_changed?
  
  include AASM

  aasm do 
  	state :unpaid, initial: true
  	state :paid, :canceled, :delivering, :finished, :deleted

    event :pay do
      transitions from: :unpaid, to: :paid, :after => [:after_pay, :send_msg_after_paid]
    end

    event :cancel do
      transitions from: :unpaid, to: :canceled
    end

    event :admin_send_it_out do
      transitions from: :paid, to: :delivering
    end

    event :get_home do
      transitions from: :delivering, to: :finished
    end

    event :canceled_by_admin do
      transitions from: :paid, to: :canceled, after: :restore_garments
    end
    
    event :soft_delete do
      transitions from: :canceled, to: :deleted
    end
  end

  def state
    I18n.t :"delivery_order.#{aasm_state}"
  end

  def amount
    delivery_cost + service_cost
  end

  def garment_ids
    self.[](:garment_ids)&.split(',')&.map(&:to_i)
  end

  def garment_ids= value
    raise 'garment_ids input must be an Array' unless value.is_a?(Array)
    self.[]=(:garment_ids, value.join(',')) 
  end

  def its_garments
    self.garments.any? ?
      self.garments :
      self.user.garments.where(id: garment_ids)
  end

  def can_be_paid
    self.user.garments.where(id: garment_ids).
      where.not(status: ['stored', 'in_basket']).any?.!
  end

  private

    def send_wechat_delivery_order_state_msg
      WechatMessageService.new(self.user).send_msg(
        'delivery_order_state_msg', self
        ) unless aasm_state.in?(['unpaid', 'deleted'])
    end

    def generate_seq
      self.seq = "D#{Time.zone.now.strftime('%Y%m%d')}#{id.to_s.rjust(6, '0')}"
      self.save
    end

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
      ).create
    end

    def send_msg_after_paid
      respond = SmsService.new('worker').new_delivery_order(self) if Rails.env == 'production'
      logger.info respond
    end

    def restore_garments
      # 管理员取消配送订单 放回衣服
      self.garments.map(&:go_back_to_chest!)
      # 退钱
      self.user.info.increment(:balance, self.amount)
      self.user.info.save!
    end

    def check_garment_ids
      garments = self.user.garments.where(id: self.garment_ids)
      errors.add(:garment_ids, "存在无效的 garment_id") if 
        garments.nil?
        # if there be any garments do not belong to current_user 
        garments.count != self.garment_ids.count || 
        # if there be any garments could not be delivered 
        garments.where.not(status: ['stored', 'in_basket']).any?
    end
  
end
