json.extract! delivery_order, :id, :seq, :can_be_paid, :garment_ids,
	:address, :name, :phone, 
	:delivery_time, :delivery_method, :remark, 
	:delivery_cost, :service_cost, 
	:aasm_state, :state, :user_id, :created_at
json.garments delivery_order.its_garments, partial: 'garments/garment', as: :garment 