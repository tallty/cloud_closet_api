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
#
# Indexes
#
#  index_user_infos_on_user_id  (user_id)
#

class UserInfo < ApplicationRecord
  belongs_to :user, dependent: :destroy
  has_many :addresses
  has_many :purchase_logs
  
  delegate :phone, to: :user

  has_one :avatar, -> { where photo_type: "avatar" }, class_name: "Image", as: :imageable, dependent: :destroy
  accepts_nested_attributes_for :avatar, allow_destroy: true

  def balance_output
    "%.2f"%self.balance
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
  
end
