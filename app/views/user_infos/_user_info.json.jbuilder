json.extract! user_info, :phone, :mail, :nickname
json.avatar image_url(user_info.avatar.try(:url, :small) || "")