# == Schema Information
#
# Table name: chests
#
#  id             :integer          not null, primary key
#  user_id        :integer
#  appointment_id :integer
#  classify       :integer
#  surplus        :integer
#  description    :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_chests_on_appointment_id  (appointment_id)
#  index_chests_on_user_id         (user_id)
#

class Chest < ApplicationRecord
  belongs_to :user
  belongs_to :appointment
  has_many :items, class_name: "ChestItem", dependent: :destroy

  ########## valideate ############
  after_create :check_chest_type

  ########## enum 衣柜类型 #########
  enum classify: {
    small_chest: 0,
    middle_chest: 1,
    big_chest: 2
  }


  def check_chest_type
    case classify
      when "small_chest"
        self.surplus = 10 - self.items.count
        self.description = "可以存10件，价格100元整"
        self.save
      when "middle_chest"
        self.surplus = 20 - self.items.count
        self.description = "可以存20件，价格200元整"
        self.save
      when "big_chest"
        self.surplus = 50 - self.items.count
        self.description = "可以存50件，价格500元整"
        self.save
    end
  end

  #衣柜别名
  def classify_alias
    I18n.t :"chest_classify.#{classify}"
  end
end
