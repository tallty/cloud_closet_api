json.extract! garment, :id, :title, :put_in_time, :expire_time, :is_new
json.cover_image image_url garment.cover_image.try(:url, :medium)