class TestPingppController < ApplicationController
  def hahaha

    @pay_order = Pingplusplus.get_pay_order(1, request.remote_ip)

    respond_with(@pay_order)

  end
end
