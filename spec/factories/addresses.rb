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

FactoryGirl.define do
  factory :address do
    name "consignee_name"
    address_detail "consignee_address"
    phone "13813813811"
  end
end
