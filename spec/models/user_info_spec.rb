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

require 'rails_helper'

RSpec.describe UserInfo, type: :model do
  it { should belong_to(:user) } 
  it { should have_one(:avatar) } 
  it { should have_many(:addresses) } 
  it { should have_many(:purchase_logs) } 
end
