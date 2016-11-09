class QueryAppointmentsController < ApplicationController

	#参数 状态 逗号隔开
	#committed,accepted,unpaid,paid,storing,stored,canceled
	def query_appointments
		_state_array = params[:state] ? params[:state].split(",") : ["committed","accepted","unpaid","paid","storing","stored","canceled"]

		@appointments = Appointment.appointment_state(_state_array)

		respond_with @appointments, template: "appointments/index", status: 200

	end

end