json.partial! "appointments/appointment", appointment: @work_appointment
json.appointment_item_groups @work_appointment.groups do |group|
  json.partial! "appointment_item_groups/appointment_item_group", appointment_item_group: group
end