# == Schema Information
#
# Table name: sms_tokens
#
#  id         :integer          not null, primary key
#  phone      :string(191)
#  token      :string(191)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_sms_tokens_on_phone  (phone)
#

class SmsToken < ApplicationRecord
  def self.register phone
    token = (0..9).to_a.sample(4).join

    sms_token = SmsToken.find_or_initialize_by phone: phone

    if phone.present?
      tpl_id = 1588030
      sms_hash = {code: token}
      
      SmsToken.send_msg phone, sms_hash, tpl_id
      
      sms_token.token = token
      sms_token.save
    end

    sms_token

  end

  def self.offline_recharge_auth_get worker, params
    worker_phone = worker.phone
    amount = params[:amount]
    token = (0..9).to_a.sample(4).join
    phone = '18802106868'
    tpl_id = '1796910'
    sms_hash = {
      worker_phone: worker.phone,
      amount: amount,
      auth_code: token
    }
    result = SmsToken.send_msg phone, sms_hash, tpl_id

    raise MyError.new(result['detail']) unless result['code'] == 0 
    SmsToken.find_or_initialize_by(
      auth_key: "worker-#{worker_phone}-#{amount}"
    ).update(token: token)
  end


  def self.offline_recharge_code_auth_validate? offline_recharge
    auth_key = "worker-#{offline_recharge.worker.phone}-#{offline_recharge.amount.to_i}"
    sms_token = SmsToken.find_by(auth_key: auth_key)
    if sms_token.nil?
      offline_recharge.errors.add(:auth_code, "授权码未获取，请先获取，或确认申请金额是否正确")
    elsif sms_token.updated_at < Time.zone.now - 15.minute
      offline_recharge.errors.add(:auth_code, "授权码已失效，请重新获取")
    
    elsif sms_token.token != offline_recharge.auth_code 
      offline_recharge.errors.add(:auth_code, "授权码不正确，请重试")
    end
  end

  def self.send_msg phone, sms_hash, tpl_id
    ChinaSMS.use :yunpian, password: "255281473668c1ef1fc752b71ce575d8"
    ChinaSMS.to phone, sms_hash, { tpl_id: tpl_id }
  end

end
