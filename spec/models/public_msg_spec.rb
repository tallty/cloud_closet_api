# == Schema Information
#
# Table name: public_msgs
#
#  id         :integer          not null, primary key
#  title      :string
#  abstract   :string
#  content    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe PublicMsg, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
