# == Schema Information
#
# Table name: distribution_items
#
#  id              :integer          not null, primary key
#  distribution_id :integer
#  garment_id      :integer
#  price           :float
#  status          :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_distribution_items_on_distribution_id  (distribution_id)
#  index_distribution_items_on_garment_id       (garment_id)
#

class DistributionItem < ApplicationRecord
  belongs_to :distribution
  belongs_to :garment
end
