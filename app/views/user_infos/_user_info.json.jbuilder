json.extract! user_info, :phone, :mail, 
	:nickname, :default_address_id, :credit, 
	:recharge_amount, :vip_level_info
json.balance user_info.balance_output
json.avatar user_info.avatar.try(:image_url, :small)
json.user_info_cover user_info.user_info_cover.try(:image_url, :product)