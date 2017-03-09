module ExhibitionChestSpaceInfo
  # 重复查询？？how?
  def max_space_count
  	_chests = ExhibitionChest.those_buddies_need_join_by(self)
  	self.need_join ?
  		_chests.map(&:max_count).reduce(:+) :
  		self.max_count
		rescue
			nil
	end

	def be_token_space_count
		_chests = ExhibitionChest.those_buddies_need_join_by(self)
		self.need_join ?
			_chests.map { |chest| chest.garments.count }.reduce(:+) :
			self.garments.count
		rescue
			nil
	end

	def remain_space_count
		self.max_count - self.be_token_count
		rescue
			nil
	end

	def it_has_space
    remain_space_count > 0
    rescue
			nil
  end

end
