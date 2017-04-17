class DeliveryService

	def initialize user
		@user = user
		@garments = user.garments
	end

	def change_garments_status params, from, to
		ids = params[:garment_ids]
		ids = ids.split(',') if ids.is_a?(String)
		@garments.where(id: ids).each { |garment|
			raise '初始状态错误' unless garment.status.in?(from)
			garment.update!(status: to)
		}
	end

end

