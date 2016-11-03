class Pingplusplus


	def self.get_pay_order open_id,amount,subject,body,client_ip

		# Pingpp::Charge.create(
	 #      :order_no  => create_order_no,
	 #      :app       => { :id => APP_ID },
	 #      :channel   => 'wx',#微信公众号支付需要 openid
	 #      :amount    => 100, #bill.amount,
	 #      :client_ip => "127.0.0.1" #request.remote_ip,
	 #      :currency  => "cny",
	 #      :subject   => "Your Subject", #bill.subject,
	 #      :body      => "Your Body" #bill.body
	 #      #:metadata => #hash 最多10项 元数据
	 #    	)
	 Pingpp::Charge.create(
                          :order_no  => Pingplusplus.new.create_order_no,
                          :app       => { :id => APP_ID },
                          :channel   => 'wx_pub',
                          :amount    => amount,
                          :client_ip => client_ip, #Pingplusplus.new.get_client_id,
                          :currency  => "cny",
                          :subject   => subject,
                          :body      => body,
                          :extra     => { :open_id => openid } #陈
                        )
		
	end

	def create_order_no
		chars =  ('0'..'9').to_a #('a'..'z').to_a + ('A'..'Z').to_a
  	Array.new(8).collect{chars[rand(chars.size - 1)]}.join 
	end

end
