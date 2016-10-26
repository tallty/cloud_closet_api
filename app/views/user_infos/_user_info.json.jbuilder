json.extract! user_info, :phone, :mail, :nickname, :balance
json.avatar user_info.avatar.try(:image_url, :small)