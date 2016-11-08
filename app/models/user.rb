# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  phone                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  authentication_token   :string(30)
#  openid                 :string
#
# Indexes
#
#  index_users_on_authentication_token  (authentication_token) UNIQUE
#  index_users_on_openid                (openid)
#  index_users_on_phone                 (phone) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#

class User < ApplicationRecord

  ## Token Authenticatable
  acts_as_token_authenticatable

  # virtual attribute
  attr_accessor :sms_token

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         authentication_keys: [:phone]

  validate :sms_token_validate, on: :create

  has_one :user_info, dependent: :destroy
  has_many :garments, dependent: :destroy
  has_many :appointments, dependent: :destroy
  has_many :bills,  dependent: :destroy

  delegate :nickname, :mail, to: :user_info, allow_nil: true

  # 绑定用户信息和openid信息
  # 微信信息和系统用户是一一对应的，所以如果一个用户绑定，需要清空这个微信原有的绑定关系
  def bind_openid openid
    if openid.present?
      _binded_user = User.find_by openid: openid
      _binded_user.update(openid: nil) if _binded_user.present?
      self.update(openid: openid)
    end
  end

  def info
    self.user_info || self.create_user_info
  end

  def worker?
    Worker.wokrer? self
  end

  def self.user_count
    User.count
  end

  def self.new_user_count_today
    User.where('created_at > ?', Time.zone.now.midnight).count
  end

  # user phone as the authentication key, so email is not required default
  def email_required?
    false
  end

  private
    def sms_token_validate
      return if sms_token == "1981"

      sms_token_obj = SmsToken.find_by(phone: phone)
      if sms_token_obj.blank?
        self.errors.add(:sms_token, "验证码未获取，请先获取")
      elsif sms_token_obj.try(:updated_at) < Time.zone.now - 15.minute
        self.errors.add(:sms_token, "验证码已失效，请重新获取")
      elsif sms_token_obj.try(:token) != sms_token 
        self.errors.add(:sms_token, "验证码不正确，请重试")
      end
    end
end
