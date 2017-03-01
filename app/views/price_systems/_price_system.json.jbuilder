json.extract! price_system, :id, :title, :price, :is_chest, :description, :unit_name, :created_at, :updated_at
json.price_icon_image price_system.price_icon_image.try(:image_url, :medium)