class Discount 

  def preferential_deposit amount　　#优惠充值
  	case amountdie
  		when "100"
  			amount + 5.0
  		when "200"
  			amount + 20.0
  		when "500"
       		amount + 60.0
  		when "1000"	
  			amount + 150.0
  		end
  end

  def special_offer_message #优惠活动
  	
  end

  def preferential_payment #优惠消费
  	
  end
end
