json.current_page @admin_appointments.current_page
json.total_pages @admin_appointments.total_pages

json.appointments @admin_appointments, partial: 'appointments/appointment', as: :appointment