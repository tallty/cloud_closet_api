# == Schema Information
#
# Table name: garments
#
#  id                  :integer          not null, primary key
#  user_id             :integer
#  title               :string
#  put_in_time         :datetime
#  expire_time         :datetime
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  seq                 :string
#  row                 :integer
#  carbit              :integer
#  place               :integer
#  aasm_state          :string           default("storing")
#  status              :string
#  stroe_mode          :string
#  appointment_id      :integer
#  exhibition_chest_id :integer
#
# Indexes
#
#  index_garments_on_appointment_id       (appointment_id)
#  index_garments_on_exhibition_chest_id  (exhibition_chest_id)
#  index_garments_on_seq                  (seq)
#  index_garments_on_user_id              (user_id)
#

class Garment < ApplicationRecord
  include AASM
  # acts_as_taggable # Alias for acts_as_taggable_on :tags
  # acts_as_taggable_on :tags, :skills
  scope :by_join_date, -> {order("created_at DESC")}

  belongs_to :user
  belongs_to :chest

  has_one :cover_image, -> { where photo_type: "cover" }, class_name: "Image", as: :imageable, dependent: :destroy
  accepts_nested_attributes_for :cover_image, allow_destroy: true

  # has_many :detail_images, -> { where photo_type: "detail" }, class_name: "Image", as: :imageable, dependent: :destroy
  # accepts_nested_attributes_for :detail_images, allow_destroy: true

  has_one :detail_image_1, -> { where photo_type: "detail_1" }, class_name: "Image", as: :imageable, dependent: :destroy
  accepts_nested_attributes_for :detail_image_1, allow_destroy: true

  has_one :detail_image_2, -> { where photo_type: "detail_2" }, class_name: "Image", as: :imageable, dependent: :destroy
  accepts_nested_attributes_for :detail_image_2, allow_destroy: true

  has_one :detail_image_3, -> { where photo_type: "detail_3" }, class_name: "Image", as: :imageable, dependent: :destroy
  accepts_nested_attributes_for :detail_image_3, allow_destroy: true

  has_many :logs, class_name: "GarmentLog", dependent: :destroy

  aasm :column => :status do
    state :storing, :initial => true
    state :stored

    event :finish_storing do
      transitions :from => :storing, :to => :stored, :after => :release_its_chest
    end
  end

  after_create :generate_seq

  def is_new
    put_in_time.blank? || put_in_time > Time.zone.now - 3.day
  end

  #存库的数量
  def garment_count 
    User.find(self.user_id).garments.where(status: 'stored').count 
  end

  #入库中的数量
  def storing_garment_count
    User.find(self.user_id).garments.where(status: 'storing').count
  end

  #管理员入库衣服后 衣服状态改为 已入库
  def do_finish_storing 
    self.finish_storing! unless self.status == 'stored'
  end

  #设置 入库时间 与 过期时间
  def set_put_in_time_and_expire_time store_month
    self.put_in_time = Time.zone.now
    # self.expire_time = self.put_in_time + store_month.to_i.month
    self.save!
  end

  #行 柜 位
  def row_carbit_place 
    "#{self.row}-#{self.carbit}-#{self.place}"  
  end


  def garment_status
    I18n.t :"appointment_itme_status.#{status}"
  end

  private
    def generate_seq
      self.seq = "G#{Time.zone.now.strftime('%Y%m%d')}#{id.to_s.rjust(6, '0')}"
      self.save
    end
  
end
