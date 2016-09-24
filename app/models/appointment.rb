# == Schema Information
#
# Table name: appointments
#
#  id         :integer          not null, primary key
#  address    :string
#  name       :string
#  phone      :string
#  number     :integer
#  date       :date
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_appointments_on_user_id  (user_id)
#

class Appointment < ApplicationRecord
  belongs_to :user
end
