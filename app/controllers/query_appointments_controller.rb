class QueryAppointmentsController < ApplicationController

	#参数 状态 逗号隔开
	#committed,accepted,unpaid,paid,storing,stored,canceled
	def query_appointment
		_state_array = params[:state].split(",") || [committed,accepted,unpaid,paid,storing,stored,canceled]
 
		@query_result = Appointment.appointment_state(_state_array)
		
		page = params[:page] || 1
    per_page = params[:per_page] || 10
    @appointments = @query_result.paginate(page: page, per_page: per_page)

		respond_with @appointments, template: "appointments/index", status: 200

	end

end