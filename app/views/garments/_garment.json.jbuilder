json.extract! garment, :id, :title, :put_in_time, :expire_time, :is_new, :garment_count, :storing_garment_count, :garment_status, :row_carbit_place, :user_id
json.cover_image garment.cover_image.try(:image_url, :medium)
json.detail_images garment.detail_images do |image|
  json.image_url image.try(:image_url, :medium)
end