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
#  number_alias       :string
#  created_by_admin   :boolean
#  meta               :text
#  appt_type          :string
#
# Indexes
#
#  index_appointments_on_user_id  (user_id)
#

class Appointment < ApplicationRecord

  default_scope { where.not( aasm_state: 'deleted' ).order('created_at DESC') }
  
  serialize :meta
  
  include AASM
  aasm do
    state :committed, initial: true
    state :accepted, :unpaid, :paid, :storing, :stored, :canceled, :deleted

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
      transitions from: [:paid, :storing], to: :stored
    end

    event :cancel do
      transitions from: [:committed, :accepted, :unpaid], to: :canceled
    end

    event :recover do 
      transitions from: :canceled, to: :unpaid
    end

    event :soft_delete do
      transitions from: :canceled, to: :deleted
    end
  end

  belongs_to :user

  has_many :garments, dependent: :destroy
  has_many :groups, class_name: "AppointmentPriceGroup", dependent: :destroy
  has_many :val_chests, source: 'valuation_chests', through: :groups

  after_create :generate_seq
  after_create :send_sms_after_created
  after_save :send_wechat_appt_state_msg, if: :aasm_state_changed?

  def state
    I18n.t :"appointment_aasm_state.#{aasm_state}"
  end
  
  scope :appointment_state, -> (state) { where( aasm_state:state ) }
  scope :by_join_date, -> {order("created_at DESC")} #降序
  scope :created_by_admin, -> { where(created_by_admin: true) }
  scope :not_by_admin, -> { where(created_by_admin: nil) }

  # 重写 garment_count_info 读写方法 attr_accessor
  def garment_count_info=(json)
    # e.g.
    #  -> params[:garment_count_info] = { hanging: 1, stacking: 10 }
    self[:garment_count_info] = json && json.map {|store_method, count| "#{store_method}:#{count}" }.join(",")
  end

  def garment_count_info
    self[:garment_count_info] && self[:garment_count_info].split(',').map{ |x| x.split(':')}.map {|store_method, count|[store_method, count.to_i]}.to_h
  end

  def other_price
    self.groups.other_items.map { |group| 
      group.price 
    }.reduce(:+) || 0
  end

  def price_except_rent
    # 服务费 护理费 真空袋等护理配件费
    _care_cost = self.care_cost || 0
    _service_cost = self.service_cost || 0
    
    _service_cost + _care_cost + other_price
  end

  def count_price
    # 租用柜子的租金
    self.rent_charge ||= 
      self.groups.chests.map { |group| 
        group.price 
      }.reduce(:+)
    raise '请填写正确的服务费用、护理费用' unless self.service_cost && self.care_cost
    # price = rent_charge + service_cost + care_cost + 真空袋等
    self.price = self.price_except_rent 
    self.price += self.rent_charge if self.rent_charge

    self.save
  end

  def set_detail
    self.detail = self.groups.map { |group| "#{group.title}, * ,#{group.count}个,#{group.price && group.price.to_s + '元/月'},#{group.store_month}" }.join(";")
    self.detail += ";服务:,#{self.service_cost};护理费:,#{care_cost};护理类型:,#{care_type};租用费总计:,#{rent_charge}"
    self.save
  end

  def worker_update_appt appt_params, appt_group_params
    ActiveRecord::Base.transaction do
      raise '订单选择错误，只可对已接受且未支付订单操作' unless self.aasm_state.in?(["accepted", "unpaid"])
      self.groups.destroy_all
      self.update(appt_params)
      self.garment_count_info = appt_params.try(:[], 'garment_count_info')
      self.save
      appt_group_params[:price_groups].each do |group_param|
        appointment_group = self.groups.build(group_param)
        appointment_group.save!
      end
      # self.check_space_and_garment_countcheck_space_and_garment_count
      self.service!
    end
    self
  end
  
  # 后台由管理员创建
  def self.create_by_admin user, appt_params, appt_group_params
    raise '禁止创建空订单。' unless appt_params.except(:appt_type).any? || appt_group_params
    ActiveRecord::Base.transaction do
      _appt = user.appointments.create!(
          {
            aasm_state: 'unpaid',
            created_by_admin: true,
            name: user.info.nickname,
            phone: user.phone,
            service_cost: 0,
            care_cost: 0,
            date: Time.now.zone
          }.merge(appt_params || {})
        )
      if appt_group_params
        appt_group_params[:price_groups].each do |group_param|
          price_group = _appt.groups.build(group_param)
          price_group.save!
        end 
      end
      _appt.service!
      _appt
    end
  end
  

  def new_chests
    # 直接使用 though 到达 exhibition_chest 会报错 ambiguous column name: aasm_state
    self.groups.collect(&:valuation_chests).reduce(:+).collect(&:exhibition_chests).map(&:to_a).reduce(:+)
  end

  # def check_space_and_garment_count
    # _count_info =  self.garment_count_info
    # self.new_chests.map do |new_chest|
    #   _count_info[ new_chest.store_method ] -= new_chest.max_count if _count_info[ new_chest.store_method ]
    # end
    # _warning = ''
    # _count_info.each { |store_method, count| _warning += "#{store_method}不足 " if count > 0}
    # raise _warning unless _warning.empty?
  # end

  private
    def send_wechat_appt_state_msg
      WechatMessageService.new(self.user).send_msg(
        'appt_state_msg', self
        ) unless aasm_state == 'deleted'
    end

    def after_pay
      # 续期
      if _chest = ExhibitionChest.find_by_id(meta&.[](:lease_renewal_chest_id))
        _chest.valuation_chest.exhibition_chests.each do |chest|
          chest.expire_time += meta[:month].months
          chest.save!
        end
      else
        create_chests
      end
      PurchaseLogService.new(
          self.user, ['appt_paid_successfully'],
          { appointment: self }
        ).create
    end

    def create_chests
      ActiveRecord::Base.transaction do
        self.groups.chests.each(&:create_relate_valuation_chest)
      end
    end

    def generate_seq
      self.seq = "A#{Time.zone.now.strftime('%Y%m%d')}#{id.to_s.rjust(6, '0')}"
      self.save
    end

    def send_sms_after_created
      respond = SmsService.new('worker').new_appt(self) if Rails.env == 'production' && created_by_admin.!
      logger.info respond
    end
end
