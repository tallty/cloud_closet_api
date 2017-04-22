class DeliveryService

	def initialize user
		@user = user
		@garments = user.garments
	end

	# 批量更新状态 必要时附上 dlivery_order
	def change_garments_status params, from_ary, to, delivery_order=nil
		ids = ids.is_a?(String) ? 
			params[:garment_ids].split(',') :
			params[:garment_ids]
		@garments = @garments.where(id: ids)
		check_state from_ary
		ActiveRecord::Base.transaction do
			@garments.each { |garment|
				garment.status = to
				garment.delivery_order = delivery_order if delivery_order
				garment.save!
			}
		end
	end

	private 
		def check_state form_ary
			raise '选择了错误起始状态的衣物' if 
        @garments.where.not(status: form_ary).any?
		end
end

