class Pingplusplus


	def self.get_pay_order open_id,amount,subject,body,client_ip

	  Pingpp::Charge.create(
                          :order_no  => Pingplusplus.new.create_order_no,
                          :app       => { :id => APP_ID },
                          :channel   => 'wx_pub',
                          :amount    => amount,
                          :client_ip => client_ip, #Pingplusplus.new.get_client_id,
                          :currency  => "cny",
                          :subject   => subject,
                          :body      => body,
                          :extra     => { :open_id => open_id } #陈
                           )
		 
	end

	# def self.get_pingpp_result
		
	# end

	def create_order_no
		chars =  ('1'..'9').to_a #('a'..'z').to_a + ('A'..'Z').to_a
  	Array.new(8).collect{chars[rand(chars.size - 1)]}.join 
	end

end
