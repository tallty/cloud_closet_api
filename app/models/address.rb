# == Schema Information
#
# Table name: addresses
#
#  id             :integer          not null, primary key
#  user_info_id   :integer
#  name           :string
#  address_detail :string
#  phone          :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_addresses_on_user_info_id  (user_info_id)
#

class Address < ApplicationRecord
  belongs_to :user_info

  def is_default
  	self.id == UserInfo.find(self.user_info_id).default_address_id
  end

end
