class TestPingppController < ApplicationController
  def hahaha

    @pay_order = Pingplusplus.get_pay_order(params[:open_id], params[:amount], params[:subject], params[:body], request.remote_ip)

    respond_with(@pay_order)

  end

#post 充值
  def recharge
  	@pay_order = Pingplusplus.get_pay_order(1, request.remote_ip)

  end
end
