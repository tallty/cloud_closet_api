# == Schema Information
#
# Table name: distributions
#
#  id         :integer          not null, primary key
#  address    :string(191)
#  name       :string(191)
#  phone      :string(191)
#  date       :date
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_distributions_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_81b70497bd  (user_id => users.id)
#

class Distribution < ApplicationRecord
  has_many :items, class_name: "DistributionItem", dependent: :destroy
end
