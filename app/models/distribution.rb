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

class Distribution < ApplicationRecord
  has_many :items, class_name: "DistributionItem", dependent: :destroy
end
