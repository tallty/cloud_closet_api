class UserMsgService

	def initialize user, source, *arg
		arg[0].each { |key, val| 
			instance_variable_set "@#{key}", val 
		} rescue []
		send(source)
		@user_msg = user.user_msgs.create(
				title: @title,
				url: @url,
				abstract: @abstract
			)
	end

	def from_wechat_msg 
		@title = @wechat_msg.instance_variable_get('@title')
		@abstract = @wechat_msg.instance_variable_get('@remark').gsub("\n", ' ')
		@url = @wechat_msg.instance_variable_get('@url')
	end

	def vip_level_up
		@title = "您升级啦!"
		@abstract = "您想现在是尊贵的#{@info_after_adding[:level_now]}！"
		@url = 'http://closet.tallty.com/user'
	end

end
