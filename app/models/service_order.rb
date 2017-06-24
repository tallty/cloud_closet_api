# == Schema Information
#
# Table name: service_orders
#
#  id           :integer          not null, primary key
#  user_id      :integer
#  rent         :float
#  care_cost    :float
#  service_cost :float
#  operation    :string
#  remark       :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_service_orders_on_user_id  (user_id)
#

class ServiceOrder < ApplicationRecord
  belongs_to :user
  has_many :appointment_price_groups

  after_create :cut_balance

  def price
    [rent, care_cost, service_cost].reject(&:blank?).reduce(:+)
  end

  private
    def cut_balance
      PurchaseLogService.new(user, 
        ['service_order'], 
        { service_order: self }
      ).create
    end
end
