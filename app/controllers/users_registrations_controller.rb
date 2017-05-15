class UsersRegistrationsController < Devise::RegistrationsController
  def create
    super
  rescue ActiveRecord::RecordNotUnique
    raise MyError.new('该手机号已被注册')
  end
end
