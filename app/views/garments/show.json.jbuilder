json.extract! @garment, :id, :title, :put_in_time, :expire_time, :is_new
json.cover_image @garment.cover_image.try(:image_url, :product)
