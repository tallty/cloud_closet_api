# == Schema Information
#
# Table name: user_infos
#
#  id                 :integer          not null, primary key
#  user_id            :integer
#  nickname           :string
#  mail               :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  default_address_id :integer
#  balance            :float            default(0.0)
#  credit             :integer          default(0)
#  recharge_amount    :integer          default(0)
#
# Indexes
#
#  index_user_infos_on_user_id  (user_id)
#

class UserInfo < ApplicationRecord
  belongs_to :user, dependent: :destroy
  has_many :addresses, dependent: :destroy
  has_many :purchase_logs, dependent: :destroy
  
  delegate :phone, to: :user

  has_one :avatar, -> { where photo_type: "avatar" }, class_name: "Image", as: :imageable, dependent: :destroy
  accepts_nested_attributes_for :avatar, allow_destroy: true
  has_one :user_info_cover, -> { where photo_type: "user_info_cover" }, class_name: "Image", as: :imageable, dependent: :destroy
  accepts_nested_attributes_for :user_info_cover, allow_destroy: true

  def balance_output
    "%.2f"%self.balance.round(2)
  end

  def refresh_default_address
  #保证默认存在
      _default_id = self.default_address_id
      unless self.addresses.empty?
        unless _default_id and self.addresses.exists?(id: _default_id)
          _default_id = self.addresses.first.id
          self.default_address_id = self.addresses.first.id
          self.save
        end
      end
  end

  def vip_level_info
    VipService.new(self).vip_in_user_info
  end
  
end
