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
#  price          :float            default(0.0)
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
    hang_chest: 0,
    preserver: 1,
    dress_chest: 2
  }

  #衣橱类型相关操作
  def check_chest_type
    self.price = 0.00 
    case self.classify
      when "hang_chest"
        self.price += 100.00
        self.surplus = 20 - self.items.count
        self.description = "可以存10件，价格100元整"
      when "preserver"
        self.price += 100.00
        self.surplus = 30 - self.items.count
        self.description = "可以存20件，价格100元整"
      when "dress_chest"
        self.price += self.items.count * 50.00
        self.surplus = 20 - self.items.count
        self.description = "可以存20件，价格500元整"
    end
    self.save
  end

  #衣柜别名
  def classify_alias
    I18n.t :"chest_classify.#{classify}"
  end
end
