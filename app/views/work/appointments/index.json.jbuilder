json.user_count User.user_count
json.new_user_count_today User.new_user_count_today

json.appointments @appointments_hash do |date, appointments|
  json.date date
  json.items appointments, partial: 'appointments/appointment', as: :appointment
end