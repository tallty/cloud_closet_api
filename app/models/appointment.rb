# == Schema Information
#
# Table name: appointments
#
#  id         :integer          not null, primary key
#  address    :string
#  name       :string
#  phone      :string
#  number     :integer
#  date       :date
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  seq        :string
#  aasm_state :string
#
# Indexes
#
#  index_appointments_on_user_id  (user_id)
#

class Appointment < ApplicationRecord
  include AASM

  aasm do
    state :committed, initial: true
    state :accepted, :unpaid, :paid, :stored, :canceled

    event :accept do
      transitions from: :committed, to: :serviced
    end

    event :service do
      transitions from: :accepted, to: :unpaid
    end

    event :pay do
      transitions from: :unpaid, to: :paid
    end

    event :store do
      transitions from: :paid, to: :store
    end

    event :cancel do
      transitions from: [:committed, :accepted, :unpaid], to: :canceled
    end
  end

  belongs_to :user
  has_many :items, class_name: "AppointmentItem", dependent: :destroy
  has_many :groups, class_name: "AppointmentItemGroup", dependent: :destroy

  after_create :generate_seq
  after_save :create_template_message, if: :aasm_state_changed?

  # 支付完成，展开预约订单，这时候可以生成相关的item和
  def pay!
    groups.each do |group|
      group.pay!
    end
  end

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
          value: user.phone,
          color: "#CCCCCC"
        },
        keyword3: {
          value: seq,
          color: "#CCCCCC"
        },
        keyword4: {
          value: "已预约",
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
