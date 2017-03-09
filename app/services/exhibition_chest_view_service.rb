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
			_chests.concat items.first.need_join ? [ items.first ] : items
		end
		_chests
	end

	def in_user_show id
		_chest = @exhibition_chests.find_by_id(id)
		raise 'id错误' unless _chest
		# 替换 衣橱详细页 garment
		_garments = []
		if _chest.need_join
			@exhibition_chests.select{ |chest| 
				chest.exhibition_unit_id == _chest.exhibition_unit_id 
			}.each { |chest| 
				_garments.concat chest.garments.stored
			}
		else
			_garments = _chest.garments.stored
		end
		[ _chest, _garments ]
	end

end
