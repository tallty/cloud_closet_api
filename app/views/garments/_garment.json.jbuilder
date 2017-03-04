json.extract! garment, :id, :title, :put_in_time, :expire_time, :is_new, :garment_status, :row_carbit_place, :user_id, :description
json.cover_image garment.cover_image.try(:image_url, :medium)
json.detail_image [ 
										garment.detail_image_1.try(:image_url, :medium), 
										garment.detail_image_2.try(:image_url, :medium),
										garment.detail_image_3.try(:image_url, :medium)
									].reject{ |x| x.nil? }
