json.extract! admin_user, :id, :phone, :email, :any_chests_about_to_expire
json.chest_count admin_user.exhibition_chests.count
json.extract! admin_user.user_info, :nickname, :balance, :credit
