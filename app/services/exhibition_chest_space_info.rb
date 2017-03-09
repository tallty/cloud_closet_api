module ExhibitionChestSpaceInfo
  # 重复查询？？how?
  def max_space_count
  	self.need_join ?
  		ExhibitionChest.those_buddies_need_join_by(self).map(&:max_count).reduce(:+) :
  		self.max_count
		rescue
			self.try(:max_count)
	end

	def be_token_space_count
		self.need_join ?
			ExhibitionChest.those_buddies_need_join_by(self).map { |chest| chest.garments.count }.reduce(:+) :
			self.garments.count
		rescue
			self.garments.count
	end

	def remain_space_count
		self.max_count - self.be_token_space_count
	end

	def it_has_space
    remain_space_count > 0
  end

end
