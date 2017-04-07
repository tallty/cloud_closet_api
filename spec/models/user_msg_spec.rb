# == Schema Information
#
# Table name: user_msgs
#
#  id         :integer          not null, primary key
#  title      :string
#  abstract   :string
#  url        :string
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_user_msgs_on_user_id  (user_id)
#

require 'rails_helper'

RSpec.describe UserMsg, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
