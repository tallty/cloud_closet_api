
json.current_page @appointments_hash.current_page
json.total_pages @appointments_hash.total_pages
json.appointments @appointments_hash do |date, appointments|
  json.date date
  json.items appointments, partial: 'appointments/appointment', as: :appointment
end