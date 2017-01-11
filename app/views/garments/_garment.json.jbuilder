json.extract! garment, :id, :title, :put_in_time, :expire_time, :is_new, :garment_status, :row_carbit_place, :tag_list, :user_id
json.cover_image garment.cover_image.try(:image_url, :medium)
json.detail_image_1 garment.detail_image_1.try(:image_url, :medium)
json.detail_image_2 garment.detail_image_2.try(:image_url, :medium)
json.detail_image_3 garment.detail_image_3.try(:image_url, :medium)
