class TestPingppController < ApplicationController
	respond_to :json

  def hahaha

    @pay_order = Pingplusplus.get_pay_order(params[:open_id], params[:amount], params[:subject], params[:body], request.remote_ip)

		render json: @pay_order
  end

  def get_pingpp_result
  	#params[:charge_id]
  	
  end
#post 充值
  def recharge

  	@pay_order = Pingplusplus.get_pay_order(1, request.remote_ip)

  end
end
