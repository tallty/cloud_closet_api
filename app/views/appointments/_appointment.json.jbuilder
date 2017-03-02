json.extract! appointment, :id, :address, :seq, :name, :phone, :number, :date, :created_at, :state, :remark, :rent_charge, :care_type, :care_cost, :service_cost, :price
json.user_avatar appointment.user.user_info.avatar.try(:image_url, :small)
if appointment.detail
	_detail = appointment.detail.split(";")
	_detail = _detail.map do |a| 
		a.split(",")
	end
	json.detail _detail
end
