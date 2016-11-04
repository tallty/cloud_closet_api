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
    status = 400

    #判断请求是否有ping++的签名信息
    # if request.headers['x-pingplusplus-signature'].blank?
    #    status = 401
    #    logger.debug '【报哪家】：======付款回调请求来源错误！！！！！'
    #    return
    # end 

    #获取签名信息
    # raw_data = request.body.read
    # if request.headers['x-pingplusplus-signature'].is_a?(Array)
    #    signature = request.headers['x-pingplusplus-signature'][0].to_s
    # else
    #    signature = request.headers['x-pingplusplus-signature'].to_s
    # end
    
    # 获取「Webhooks 验证 Ping++ 公钥」
    # pub_key_path ="#{Rails.root}/config/rsa_public_key.pem"
    # if verify_signature(raw_data, signature, pub_key_path)
           #处理接收的结果
         event = JSON.parse(raw_data) 
         #付款成功
         if event["type"] == 'charge.succeeded'

          # 开发者在此处加入对支付异步通知的处理代码
            ping_id = event['data']['object']['id']
            ping_request = PingRequest.where(ping_id: ping_id).first

            if ping_request.present?
                #更新字段
                ping_request.complete = event['data']['object']['paid']  

                #发送微信消息  
                if ping_request.save
                     status = 200
                else
                    status = 500
                end
            else
                   logger.debug '数据库没有该条记录！'
            end

          #退款成功
        # elsif event['type'] == 'refund.succeeded'

        #       # 开发者在此处加入对退款异步通知的处理代码
        #     order_no = event['data']['object']['order_no']
        #     order = Order.where(order_no: order_no).first
        #     if order.present?
        #         #更新字段
        #         order.time_refunded = Time.at(event['data']['object']['time_succeed'])
        #         if order.save
        #             status = 200
        #         else
        #             status = 500
        #         end
        #     else
        #           logger.debug '数据库没有该条记录！'
        #     end

        # else
        #     logger.debug '付款回调返回未知操作！'
        # end

      # else
      #    logger.debug '付款回调请求来源错误！'
      #    status = 403
      end
      render :nothing => true, :status => status
    # end	
	end






end
