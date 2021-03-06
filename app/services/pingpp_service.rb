class PingppService

	def get_pay_order params
		params = params.permit(
        :openid, :amount, :subject, :body, :credits
        )
		#选择支付方式
		channel = params[:channel] || 'wx_pub'
		extra = {}
		case channel
		when 'wx_pub'
			#ping++ 平台发起创建时  openid 需要下划线 open_id
			_extra = { open_id: params[:openid] }
		end
		
    @ping_request = PingRequest.new(
      order_no: create_order_no,
      channel: _channel,
      client_ip: request.remote_ip,
      extra: _extra,
      amount: params[:amount],
      subject: params[:subject],
      body: params[:body],
      openid: params[:openid],
      metadata: params[:metadata]
      )

		#在ping++平台创建一条记录
		_charge = @ping_request.get_pay_order(_extra) 

		if _charge 
			@ping_request.ping_id = _charge[:id]
			@ping_request.save
		  render json: _charge 
		end
		_charge
		rescue Pingpp::PingppError => error
              logger.error 'ping++平台创建订单失败'
              logger.error error.http_body
    error
	end



	def create_order_no #order_no 允许重复
    chars =  ('1'..'9').to_a + ('a'..'z').to_a + ('A'..'Z').to_a
    Array.new(8).collect{chars[rand(chars.size - 1)]}.join 
  end


end