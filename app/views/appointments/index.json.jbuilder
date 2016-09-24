json.current_page @appointments.current_page
json.total_pages @appointments.total_pages

json.appointments @appointments, partial: 'appointments/appointment', as: :appointment