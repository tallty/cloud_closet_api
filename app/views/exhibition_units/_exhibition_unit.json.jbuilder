json.extract! exhibition_unit, :id, :title, :store_method, :need_join, :price_system_id
json.exhibition_icon_image exhibition_unit.exhibition_icon_image.try(:image_url, :medium)