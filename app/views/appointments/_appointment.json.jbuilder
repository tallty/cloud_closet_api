json.extract! appointment, :id, :address, :seq, :name, :phone, :number, :date, :created_at, :state, :price

if appointment.detail
	_detail = appointment.detail.split(";")
	_detail = _detail.map do |a| 
		a.split(",")
	end
	json.detail _detail
end

json.appointment_item_groups appointment.groups do |group|
  json.partial! "appointment_item_groups/appointment_item_group", appointment_item_group: group
end