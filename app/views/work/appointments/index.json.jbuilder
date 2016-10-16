json.appointments @appointments_hash do |date, appointments|
  json.date date
  json.items appointments, partial: 'appointments/appointment', as: :appointment
end