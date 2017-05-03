# == Schema Information
#
# Table name: store_methods
#
#  id         :integer          not null, primary key
#  title      :string(191)
#  zh_title   :string(191)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class StoreMethod < ApplicationRecord
end
