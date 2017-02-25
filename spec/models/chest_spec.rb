# == Schema Information
#
# Table name: chests
#
#  id                     :integer          not null, primary key
#  title                  :string
#  chest_type             :string
#  max_count              :integer
#  user_id                :integer
#  price_system_id        :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  end_day                :date
#  start_day              :date
#  last_time_inc_by_month :integer
#  aasm_state             :string
#
# Indexes
#
#  index_chests_on_price_system_id  (price_system_id)
#  index_chests_on_user_id          (user_id)
#

require 'rails_helper'

RSpec.describe Chest, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
