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
#  status              :string
#  store_method        :string
#  appointment_id      :integer
#  exhibition_chest_id :integer
#  description         :text
#  delivery_order_id   :integer
#
# Indexes
#
#  index_garments_on_appointment_id       (appointment_id)
#  index_garments_on_delivery_order_id    (delivery_order_id)
#  index_garments_on_exhibition_chest_id  (exhibition_chest_id)
#  index_garments_on_seq                  (seq)
#  index_garments_on_user_id              (user_id)
#

class Garment < ApplicationRecord
  include AASM
  # acts_as_taggable # Alias for acts_as_taggable_on :tags
  acts_as_taggable_on :tags

  belongs_to :user
  belongs_to :exhibition_chest
  belongs_to :appointment
  belongs_to :delivery_order

  has_one :cover_image, -> { where photo_type: "cover" }, class_name: "Image", as: :imageable, dependent: :destroy
  accepts_nested_attributes_for :cover_image, allow_destroy: true

  has_one :detail_image_1, -> { where photo_type: 'detail_1' }, class_name: 'Image', as: :imageable, dependent: :destroy
  accepts_nested_attributes_for :detail_image_1, allow_destroy: true

  has_one :detail_image_2, -> { where photo_type: 'detail_2' }, class_name: 'Image', as: :imageable, dependent: :destroy
  accepts_nested_attributes_for :detail_image_2, allow_destroy: true

  has_one :detail_image_3, -> { where photo_type: 'detail_3' }, class_name: 'Image', as: :imageable, dependent: :destroy
  accepts_nested_attributes_for :detail_image_3, allow_destroy: true


  aasm :column => :status do
    state :storing, :initial => true
    state :stored, :in_basket, :delivering, :at_home

    event :finish_storing do
      transitions from: [:storing, :stored], to: :stored, after:  :set_put_in_time_and_expire_time
    end

    event :add_to_basket do 
      transitions from: :stored, to: :in_basket
    end

    event :come_back_to_chest do 
      transitions from: :in_basket, to: :stored
    end

    event :begin_delivering do 
      transitions from: :in_basket, to: :delivering
    end

    event :arrive_home do 
      transitions from: :delivering, to: :at_home
    end

    event :go_back_to_chest do
      transitions from: :delivering, to: :stored, after: :leave_delivery_order
    end
  end

  after_create :set_store_method_and_user
  after_create :generate_seq

  
  scope :by_join_date, -> {order("created_at DESC")}
  scope :can_be_delivered, -> { where( status: ['stored', 'in_basket'])}
  scope :in_chest, -> { where( status: ['storing', 'stored', 'in_basket'])}
  def is_new
    put_in_time.blank? || put_in_time > Time.zone.now - 3.day
  end

  # 存库的数量
  def garment_count 
    User.find(self.user_id).garments.where(status: 'stored').count 
  end

  # 入库中的数量
  def storing_garment_count
    User.find(self.user_id).garments.where(status: 'storing').count
  end

  #管理员入库衣服后 衣服状态改为 已入库
  def do_finish_storing 
    self.finish_storing! unless self.status == 'stored'
  end

  #设置 入库时间 与 过期时间
  def set_put_in_time_and_expire_time 
    self.put_in_time = Time.zone.now unless self.put_in_time
    self.save!
  end

  #行 柜 位
  def row_carbit_place 
    "#{self.row}-#{self.carbit}-#{self.place}"  
  end

  def garment_status
    I18n.t :"garment.#{status}"
  end

  private
    def generate_seq
      self.seq = "G#{Time.zone.now.strftime('%Y%m%d')}#{id.to_s.rjust(6, '0')}"
      self.save
    end

    def set_store_method_and_user
      self.store_method = self.exhibition_chest.store_method
      self.user = self.exhibition_chest.user
      self.save
    end

    def leave_delivery_order
      self.delivery_order_id = nil
      # self.save
    end
end
