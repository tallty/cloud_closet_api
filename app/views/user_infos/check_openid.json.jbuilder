if @user.present?
  json.extract! @user, :phone, :authentication_token
end