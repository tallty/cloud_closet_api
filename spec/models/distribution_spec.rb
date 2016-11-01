# == Schema Information
#
# Table name: distributions
#
#  id         :integer          not null, primary key
#  address    :string
#  name       :string
#  phone      :string
#  date       :date
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_distributions_on_user_id  (user_id)
#

require 'rails_helper'

RSpec.describe Distribution, type: :model do
  it { should have_many(:items) } 
end
