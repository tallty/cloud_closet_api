json.extract! price_system, :id, :name, :season, :price, :created_at, :updated_at
json.icon_image price_system.icon_image.try(:image_url, :medium)