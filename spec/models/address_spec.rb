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

require 'rails_helper'

RSpec.describe Address, type: :model do
	it { should belong_to(:user_info) }
end
