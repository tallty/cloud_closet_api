class PingppController < ApplicationController
	respond_to :json

	#得到支付凭证 创建ping_request对象
	def get_pay_order 

		#选择支付方式
		_channel = 'wx_pub' #params[:channel] || 'wx_pub'
		_extra = {}
		case _channel
		when 'wx_pub'
			_extra[:open_id] = params[:open_id] 
		end

		@ping_request = PingRequest.new(
			order_no: PingRequest.create_order_no,
			channel: _channel,
			amount: params[:amount],
			client_ip: "127.0.0.1",#request.remote_ip,
			subject: params[:subject],
			body: params[:body],
			extra: _extra
			)

		#在ping++平台创建一条记录
		_charge = @ping_request.get_pay_order(_extra)

		if _charge 
			@ping_request.ping_id = _charge[:id]
			@ping_request.save
		  render json: _charge
		end

		rescue Pingpp::PingppError => error
              logger.error 'ping++平台创建订单失败'
              logger.error error.http_body
    render json: error

	end


	def get_pingpp_webhooks
		
	end






end
