
json.state_appointments @work_appointments do |date, appointments|
  json.date date
  json.items appointments, partial: 'appointments/appointment', as: :appointment
end