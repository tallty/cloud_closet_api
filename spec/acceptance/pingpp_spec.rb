require 'acceptance_helper'

resource "ping++平台支付相关" do
  header "Accept", "application/json"

  post '/get_pingpp_pay_order' do
  	parameter :channel, "支付渠道",required: false
  	parameter :openid, "用户openid", required: true
  	parameter :amount, "金额, 100=1元", required: true
  	parameter :subject, "充值/消费/提现", required: true
  	parameter :body, "余额充值/购买衣橱/衣服配送/余额提现", required: true
  	parameter :metadata, '其他描述，键值对，例：\'{"detail":"裤子*2 衣服*4"}\'', required: false
    

    let(:channel) { 'wx_pub' }
    let(:openid) { "olclvwHtOBENZ-rLA2NxsBCVZky0" }
    let(:amount) { "100" }
    let(:subject) { "充值" }
    let(:body) { "余额充值" }
    # let(:metadata) { '{"detail":"裤子*2 衣服*4"}' }

    example "向ping++平台请求支付凭证" do
      do_request
      puts response_body
      expect(status).to eq(200)
     end
  end

end