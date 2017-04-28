json.extract! appointment, :id, :address, :seq, :user_id,
	:name, :phone, :number, :date, :created_at, 
	:state, :remark, :rent_charge, :care_type, 
	:care_cost, :service_cost, :price, :price_except_rent,
	:garment_count_info, :detail
json.user_avatar appointment.user.info.avatar.try(:image_url, :small)

json.appointment_price_groups appointment.groups, partial: 'appointment_price_groups/appointment_price_group', as: :appointment_price_group

if appointment.detail
	_detail = appointment.detail.split(";")
	_detail = _detail.map do |a| 
		a.split(",")
	end
	json.detail _detail
end
