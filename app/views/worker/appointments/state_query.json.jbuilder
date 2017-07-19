json.accepted_appointments @accepted_appointments do |date, appointments|
  json.date date
  json.items appointments, partial: 'appointments/appointment', as: :appointment
end

json.waiting_appointments @waiting_appointments do |date, appointments|
  json.date date
  json.items appointments, partial: 'appointments/appointment', as: :appointment
end

json.history_appointments @history_appointments do |date, appointments|
  json.date date
  json.items appointments, partial: 'appointments/appointment', as: :appointment
end
