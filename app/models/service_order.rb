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
  has_many :groups, class_name: "AppointmentPriceGroup"

  def price
    [rent, care_cost, service_cost].reject(&:blank?).reduce(:+)
  end

  def self.create_by_admin user, service_order_params, service_order_group_params
   ActiveRecord::Base.transaction do
      _service_order = user.service_orders.new
      _service_order.update!(service_order_params) if service_order_params
      if service_order_group_params
        rent = 0
        service_order_group_params[:price_groups].each do |group_param|
          price_group = _service_order.groups.build(group_param)
          price_group.save!
          price_group.create_relate_valuation_chest
          rent += price_group.price
        end 
        _service_order.update!(rent: rent)
      end
      _service_order.cut_balance
      _service_order
    end
  end
  
  # 可能需要单独出 接口操作
  def cut_balance
    PurchaseLogService.new(user, 
      ['service_order'], 
      { service_order: self }
    ).create
  end

end
