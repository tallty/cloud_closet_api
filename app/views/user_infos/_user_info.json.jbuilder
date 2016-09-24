json.extract! user_info, :phone, :mail, :nickname
json.avatar user_info.avatar.try(:image_url, :small)