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
		@url = @wechat_msg.instance_variable_get('@url')
		@abstract = @wechat_msg.instance_variable_get('@remark').gsub("\n", ' ')
	end

end
