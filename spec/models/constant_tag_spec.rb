# == Schema Information
#
# Table name: constant_tags
#
#  id         :integer          not null, primary key
#  title      :string
#  class_type :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe ConstantTag, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
