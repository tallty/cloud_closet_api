# == Schema Information
#
# Table name: price_systems
#
#  id         :integer          not null, primary key
#  name       :string
#  season     :string
#  price      :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class PriceSystem < ApplicationRecord
	has_one :icon_image, -> { where photo_type: "icon" }, class_name: "Image", as: :imageable, dependent: :destroy
  accepts_nested_attributes_for :icon_image, allow_destroy: true

  validates_uniqueness_of :name, scope: [:season]

  scope :price_system_name, -> (name) {where(name:name)}
  scope :price_system_season, -> (season) {where(season: season)}
end
