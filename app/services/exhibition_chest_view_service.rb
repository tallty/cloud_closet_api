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

	def in_user_show chest_id
		_chest = @exhibition_chests.find_by_id(chest_id)
		raise 'id错误' unless _chest
		# 替换 衣橱详细页 garment
		_garments = []
		if _chest.need_join
			@exhibition_chests.select{ |chest| 
				chest.exhibition_unit_id == _chest.exhibition_unit_id 
			}.each { |chest| 
				_garments.concat chest.garments
			}
		else
			_garments = _chest.garments
		end
		[ 
			_chest, 
			_garments.reject{ 
				|garment| garment.status.in?(['in_basket'])} 
			]
	end

	def chest_other_info user
		# garment_count   包含几种状态的衣服？？？？？？
		# 现在显示的是 仅 stored 
		graments_count = @exhibition_chests.collect(&:garments).reduce(:+)&.select{ 
				|garment| garment.status.in?(['storing', 'stored', 'in_basket'])
			}&.count || 0
		storing_garments_count = user.garments.storing.count

		{
			graments_count: graments_count,
			storing_garments_count: storing_garments_count
		}
	end


end
