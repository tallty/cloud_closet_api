# == Schema Information
#
# Table name: chests
#
#  id             :integer          not null, primary key
#  user_id        :integer
#  appointment_id :integer
#  classify       :integer
#  surplus        :integer
#  description    :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_chests_on_appointment_id  (appointment_id)
#  index_chests_on_user_id         (user_id)
#

class Chest < ApplicationRecord
  belongs_to :user
  belongs_to :appointment
end
