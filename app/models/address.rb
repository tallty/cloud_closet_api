# == Schema Information
#
# Table name: addresses
#
#  id             :integer          not null, primary key
#  user_info_id   :integer
#  name           :string(191)
#  address_detail :string(191)
#  phone          :string(191)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  house_number   :string(191)
#  sex            :integer
#
# Indexes
#
#  index_addresses_on_user_info_id  (user_info_id)
#
# Foreign Keys
#
#  fk_rails_7e2a135908  (user_info_id => user_infos.id)
#

class Address < ApplicationRecord
  belongs_to :user_info

  enum sex: {
  	man: 0,
  	women: 1
  }

  def is_default
  	self.id == UserInfo.find(self.user_info_id).default_address_id
  end

end
