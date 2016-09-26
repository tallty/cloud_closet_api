if @openid.present? && @user.present?
  json.extract! @user, :phone, :authentication_token
else
  json.error "该openid绑定的用户不存在"
end