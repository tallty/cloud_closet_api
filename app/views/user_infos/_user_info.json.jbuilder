json.extract! user_info, :phone, :mail, :nickname, :balance, :balance_output, :default_address_id
json.avatar user_info.avatar.try(:image_url, :small)
json.user_info_cover user_info.user_info_cover.try(:image_url, :product)