json.extract! purchase_log, :id, :user_info_id, :balance, 
	:operation, :payment_method,
	:change_output, :what_day, :date, :time, 
	:created_at, :updated_at

if purchase_log.detail
	_detail = purchase_log.detail.split(";")
	_detail = _detail.map do |a| 
		a.split(",")
	end
	json.detail _detail
end

json.url purchase_log_url(purchase_log, format: :json)