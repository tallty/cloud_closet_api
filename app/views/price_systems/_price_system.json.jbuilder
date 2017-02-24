json.extract! price_system, :id, :title, :price, :item_type, :max_count_per, :created_at, :updated_at
json.icon_image price_system.icon_image.try(:image_url, :medium)