json.extract! appointment, :id, :address, :seq, :name, :phone, :number, :date, :created_at, :state, :price, :detail
json.appointment_item_groups appointment.groups do |group|
  json.partial! "appointment_item_groups/appointment_item_group", appointment_item_group: group
end