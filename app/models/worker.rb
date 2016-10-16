class Worker

  def self.worker? user
    phone_list.include? user.try(:phone) 
  end

  def self.phone_list
    [
      "18616591019",
      "18516591232",
      "18516512221"
    ]
  end
end