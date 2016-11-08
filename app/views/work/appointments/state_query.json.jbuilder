
json.current_page @work_appointments.current_page
json.total_pages @work_appointments.total_pages
json.state_appointments @work_appointments, partial: 'appointments/appointment', as: :appointment