# == Schema Information
#
# Table name: images
#
#  id                 :integer          not null, primary key
#  title              :string
#  photo_type         :string
#  photo_file_name    :string
#  photo_content_type :string
#  photo_file_size    :integer
#  photo_updated_at   :datetime
#  imageable_type     :string
#  imageable_id       :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
# Indexes
#
#  index_images_on_imageable_type_and_imageable_id  (imageable_type,imageable_id)
#

class Image < ApplicationRecord

  belongs_to :imageable, polymorphic: true

  # paperclip gem
  has_attached_file :photo, styles: { mini: '48x48>', small: '150x150>', medium: '300x300>', product: '600x600>', large: '1280x1280>' }

  validates_attachment_presence :photo
  validates_attachment_size     :photo, less_than: 5.megabytes
  validates_attachment_content_type :photo, content_type: /image\/.*\Z/

  def url mode=:medium
    photo.present? ? photo.url(mode) : ""
  end

  def image_url mode=:medium
    ActionController::Base.helpers.image_url( url(mode) ) || ""
  end
end
