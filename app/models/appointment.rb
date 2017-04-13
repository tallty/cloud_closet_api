# == Schema Information
#
# Table name: appointments
#
#  id                 :integer          not null, primary key
#  address            :string
#  name               :string
#  phone              :string
#  number             :integer
#  date               :date
#  user_id            :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  seq                :string
#  aasm_state         :string
#  price              :float            default(0.0)
#  detail             :string
#  remark             :text
#  care_type          :string
#  care_cost          :float
#  service_cost       :float
#  rent_charge        :float
#  garment_count_info :string
#  hanging_count      :integer          default(0)
#  stacking_count     :integer          default(0)
#  full_dress_count   :integer          default(0)
#
# Indexes
#
#  index_appointments_on_user_id  (user_id)
#

class Appointment < ApplicationRecord
  include AASM

  aasm do
    state :committed, initial: true
    state :accepted, :unpaid, :paid, :storing, :stored, :canceled

    event :accept do
      transitions from: :committed, to: :accepted
    end

    event :service do
      transitions from: [:accepted, :unpaid], to: :unpaid, :after => [:count_price, :set_detail]
    end

    event :pay do
      transitions from: :unpaid, to: :paid, :after => :after_pay
    end

    event :storing do
      transitions form: :paid, to: :storing
    end

    event :stored do
      transitions from: :storing, to: :stored, :after => :after_stored
    end

    event :cancel do
      transitions from: [:committed, :accepted, :unpaid], to: :canceled
    end
  end

  belongs_to :user

  has_many :graments
  has_many :groups, class_name: "AppointmentPriceGroup", dependent: :destroy
  has_many :val_chests, source: 'valuation_chests', through: :groups

  after_create :generate_seq
  after_create :send_sms
  after_save :send_wechat_appt_state_msg, if: :aasm_state_changed?

  def state
    I18n.t :"appointment_aasm_state.#{aasm_state}"
  end

  
  scope :appointment_state, -> (state) {where(aasm_state:state)}
  scope :by_join_date, -> {order("created_at DESC")} #降序
                                                     #
  # 重写 garment_count_info 读写方法 attr_accessor
  def garment_count_info=(json)
    # e.g.
    #  -> params[:garment_count_info] = { hanging: 1, stacking: 10 }
    self[:garment_count_info] = json && json.map {|store_method, count| "#{store_method}:#{count}" }.join(",")
  end

  def garment_count_info
    self[:garment_count_info] && self[:garment_count_info].split(',').map{ |x| x.split(':')}.map {|store_method, count|[store_method, count.to_i]}.to_h
  end

  def price_except_rent
    # 服务费 护理费 真空袋等护理配件费
    _care_cost = self.care_cost || 0
    _service_cost = self.service_cost || 0
    _other_price = self.groups.other_items.map { |group| 
        group.price 
      }.reduce(:+) || 0
    _service_cost + _care_cost + _other_price
  end

  def count_price
    # 租用柜子的租金
    self.rent_charge = 
      self.groups.chests.map { |group| 
        group.price 
      }.reduce(:+)
    raise '请填写正确的服务费用、护理费用' unless self.service_cost && self.care_cost
    self.price = self.price_except_rent 
    self.price += self.rent_charge if self.rent_charge

    self.save
  end

  def set_detail
    self.detail = self.groups.map { |group| "#{group.title}, * ,#{group.count}个,#{group.price && group.price.to_s + '元/月'},#{group.store_month}" }.join(";")
    self.detail += ";服务:,#{self.service_cost};护理费:,#{care_cost};护理类型:,#{care_type};租用费总计:,#{rent_charge}"
    self.save
  end

  def worker_update_appt params
    appt_params = params.require(:appointment).permit(
          :remark, :care_type, :care_cost, :service_cost,
          :garment_count_info
        )
    appt_group_params = params.require(:appointment_items).permit(
        price_groups: [
          :price_system_id, :count, :store_month,
        ]
      )

    ActiveRecord::Base.transaction do

      raise '订单选择错误，只可对已接受且未支付订单操作' unless self.aasm_state.in?(["accepted", "unpaid"])
      self.groups.destroy_all
      self.update(appt_params)
      
      self.garment_count_info = params['appointment'].try(:[], 'garment_count_info')
      self.save
      
      appt_group_params[:price_groups].each do |group_param|
        appointment_group = self.groups.build(group_param)
        appointment_group.save!
      end
      self.check_space_and_garment_count
      self.service!
    end
    self
  # rescue => error
  end

  def new_chests
    self.groups.collect(&:exhibition_chests).map(&:to_a).reduce(:+)
  end

  def check_space_and_garment_count
    _count_info =  self.garment_count_info
    p _count_info
    user = self.user
    self.new_chests.map do |new_chest|
      _count_info[ new_chest.store_method ] -= new_chest.max_count if _count_info[ new_chest.store_method ]
    end
    _warning = ''
    _count_info.each { |store_method, count| _warning += "#{store_method}不足 " if count > 0}
    raise _warning unless _warning.empty?
  end

  private
    def send_wechat_appt_state_msg
      WechatMessageService.new(self.user).send_msg(
        'appt_state_msg', self
        )
    end

    def after_pay
      PurchaseLogService.new(
          self.user, ['service_cost', 'case_cost'],
          { appointment: self }
        ).create
    end

    def after_stored
      PurchaseLogService.new(
          user, ['new_chest_rent'], 
          { appointment: self }
        ).create
    end

    def generate_seq
      self.seq = "A#{Time.zone.now.strftime('%Y%m%d')}#{id.to_s.rjust(6, '0')}"
      self.save
    end

    def send_sms
      respond = SmsService.new('worker').new_appt(self) if Rails.env == 'production'
      logger.info respond
    end
end
