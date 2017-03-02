# Appointment.aasm.state_machine.states.collect(&:name).each do |state|
#   json.send("#{state}_appointments", instance_variable_get("@#{state}_appointments")), 
# end
# output = Proc.new do |state|
#   json.date date
#   json.items appointments, partial: 'appointments/appointment', as: :appointment
# end 
#  暂缓

json.accepted_appointments @accepted_appointments do |date, appointments|
  json.date date
  json.items appointments, partial: 'appointments/appointment', as: :appointment
end

json.unpaid_appointments @unpaid_appointments do |date, appointments|
  json.date date
  json.items appointments, partial: 'appointments/appointment', as: :appointment
end

json.paid_appointments @paid_appointments do |date, appointments|
  json.date date
  json.items appointments, partial: 'appointments/appointment', as: :appointment
end

json.storing_appointments @storing_appointments do |date, appointments|
  json.date date
  json.items appointments, partial: 'appointments/appointment', as: :appointment
end

json.canceled_appointments @canceled_appointments do |date, appointments|
  json.date date
  json.items appointments, partial: 'appointments/appointment', as: :appointment
end