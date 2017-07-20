class ExhibitionChestViewService

	def initialize exhibition_chests
		@exhibition_chests = exhibition_chests
		@exhibition_units = ExhibitionUnit.all
	end

	def in_user_index
		_chests = []
		# chunk 不排序..? [1,[]],[2,[]],[1,[]]
		@exhibition_chests.sort_by(&:exhibition_unit_id).chunk(&:exhibition_unit_id).each do |unit_id, items|
			next unless items.any? 
			_chests.concat( items.first.need_join ? [ items.first ] : items )
		end
		_chests
	end

	def in_user_show chest_id, &garment_scope
		_chest = @exhibition_chests.find_by_id(chest_id)
		raise 'id错误' unless _chest
		# 替换 衣橱详细页 garment

		_garments = _chest.need_join ?
			@exhibition_chests.where(exhibition_unit: _chest.exhibition_unit).map(&:garments).reduce(:or).in_chest :
			_chest.garments.in_chest
			
		[ 
			_chest, 
			garment_scope&.call(_garments) || _garments
		]
	end

	def chest_other_info user
		graments_count = @exhibition_chests.collect(&:garments).reduce(:+)&.reject{ 
				|garment| garment.at_home?
			}&.count || 0
		storing_garments_count = user.garments.storing.count

		{
			graments_count: graments_count,
			storing_garments_count: storing_garments_count
		}
	end


end
