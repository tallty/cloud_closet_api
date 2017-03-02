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
      transitions from: [:accepted, :unpaid], to: :unpaid, :after => :count_price
    end

    event :pay do
      transitions from: :unpaid, to: :paid
    end

    event :storing do
      transitions form: :paid, to: :storing
    end

    event :stored do
      transitions from: :storing, to: :stored
    end

    event :cancel do
      transitions from: [:committed, :accepted, :unpaid], to: :canceled
    end
  end

  belongs_to :user

  has_many :graments
  has_many :groups, class_name: "AppointmentPriceGroup", dependent: :destroy
  has_many :new_chests, class_name: "AppointmentNewChest", dependent: :destroy

  after_create :generate_seq
  after_save :create_template_message, if: :aasm_state_changed?

  def state
    I18n.t :"appointment_aasm_state.#{aasm_state}"
  end

  
  scope :appointment_state, -> (state) {where(aasm_state:state)}
  scope :by_join_date, -> {order("created_at DESC")} #降序
                                                     #
  # 重写 garment_count_info 读写方法 attr_accessor
  def garment_count_info=(json)
    # e.g. -> params[:garment_count_info] = { hanging: 1, stacking: 10 }
    self[:garment_count_info] = json && json.map {|store_method, count| "#{store_method}:#{count}" }.join(",")
  end

  def garment_count_info
    self[:garment_count_info] && self[:garment_count_info].split(',').map{ |x| x.split(':')}.map {|store_method, count|[store_method, count.to_i]}.to_h
  end

  def price_except_rent
    self.service_cost.try(:+, self.care_cost)
  end

  def count_price
    self.rent_charge = self.groups.map {|group| group.price }.reduce(:+)
    raise '请填写正确的服务费用、护理费用' unless self.service_cost && self.care_cost
    self.price = self.rent_charge + self.price_except_rent
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
      
      self.service!
    end
    self
  # rescue => error
  end
## !!!
  # def do_stored_if_its_garments_are_all_stored 
  #   self.stored! unless self.aasm_state == 'stored' || self.items.collect(&:garment).each {|x| return true if x.status == 'storing'}
  # end

  def create_template_message
    openid = user.try(:openid)
    return if openid.blank?
    template = {
      template_id: "6M5zwt6mJeqk6E29HnVj2qdlyA68O9E-NNP4voT1wBU",
      url: "http://closet.tallty.com/orders",
      topcolor: "#FF0000",
      data: {
        first: {
          value: "亲，您的预约订单状态变更，请注意查看。",
          color: "#0A0A0A"
        },
        keyword1: {
          value: "乐存好衣",
          color: "#CCCCCC"
        },
        keyword2: {
          value: user.phone,#商家电话？？？？！！！！
          color: "#CCCCCC"
        },
        keyword3: {
          value: seq,
          color: "#CCCCCC"
        },
        keyword4: {
          value: state,
          color: "#CCCCCC"
        },
        keyword5: {
          value: "上门评估",
          color: "#CCCCCC"
        },
        remark: {
          value: "请您留意上门时间，合理安排好您的时间",
          color: "#173177"
        }
      }
    }
    if state == 'stored'
      template[:url] = 'http://closet.tallty.com/MyCloset' 
      template[:data][:keyword3] = nil
      template[:data][:remark] = nil
    end
    
    response = Faraday.post 'http://wechat-api.tallty.com/cloud_closet_wechat/template_message',
      { openid: openid, template: template}
    puts response.body
  end

  private
    def generate_seq
      self.seq = "A#{Time.zone.now.strftime('%Y%m%d')}#{id.to_s.rjust(6, '0')}"
      self.save
    end
end
