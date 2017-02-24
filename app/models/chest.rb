# == Schema Information
#
# Table name: chests
#
#  id              :integer          not null, primary key
#  title           :string
#  chest_type      :string
#  max_count       :integer
#  user_id         :integer
#  price_system_id :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_chests_on_price_system_id  (price_system_id)
#  index_chests_on_user_id          (user_id)
#

class Chest < ApplicationRecord
  belongs_to :user
  belongs_to :price_system
end
