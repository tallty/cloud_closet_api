# == Schema Information
#
# Table name: bills
#
#  id         :integer          not null, primary key
#  bill_type  :integer          default(0)
#  seq        :string
#  sign       :string
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  price      :float            default(0.0)
#
# Indexes
#
#  index_bills_on_user_id  (user_id)
#

require 'rails_helper'

RSpec.describe Bill, type: :model do
   it { should belong_to(:user) } 
end
