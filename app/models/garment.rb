# == Schema Information
#
# Table name: garments
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  title       :string
#  put_in_time :datetime
#  expire_time :datetime
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  seq         :string
#  row         :integer
#  carbit      :integer
#  place       :integer
#  aasm_state  :string
#
# Indexes
#
#  index_garments_on_seq      (seq)
#  index_garments_on_user_id  (user_id)
#

class Garment < ApplicationRecord
  include AASM
  acts_as_taggable # Alias for acts_as_taggable_on :tags
  acts_as_taggable_on :tags, :skills
  scope :by_join_date, -> {order("created_at DESC")}

  belongs_to :user

  has_one :cover_image, -> { where photo_type: "cover" }, class_name: "Image", as: :imageable, dependent: :destroy
  accepts_nested_attributes_for :cover_image, allow_destroy: true

  has_many :detail_images, -> { where photo_type: "detail" }, class_name: "Image", as: :imageable, dependent: :destroy
  accepts_nested_attributes_for :detail_images, allow_destroy: true

  has_many :logs, class_name: "GarmentLog", dependent: :destroy
  has_many :items, class_name: "ChestItem", dependent: :destroy

  after_create :update_aasm_state
      
  aasm do
    state :storing, :initial => true
    state :stored
      
    event :store do
      transitions :from => :storing, :to => :stored
    end
  end

  def update_aasm_state
    self.store!
  end

  def state
    I18n.t :"garment_aasm_state.#{aasm_state}"
  end

  def is_new
    put_in_time.blank? || put_in_time > Time.zone.now - 3.day
  end

  scope :garment_state, -> (state) {where(aasm_state: state)}

  def storing_garment_count#入库中的数量
    Garment.all.garment_state("storing").count 
  end

  def stored_garment_count #存库的数量
    Garment.all.count 
  end

  def row_carbit_place
    "#{self.row}-#{self.carbit}-#{self.place}"  
  end

  after_create :generate_seq

  private
    def generate_seq
      self.seq = "G#{Time.zone.now.strftime('%Y%m%d')}#{id.to_s.rjust(6, '0')}"
      self.save
    end  
end
