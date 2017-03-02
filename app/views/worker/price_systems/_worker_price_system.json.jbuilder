json.extract! price_system, :id, :title, :price, :is_chest, :description, :unit_name
json.price_icon_image price_system.price_icon_image.try(:image_url, :medium)
json.exhibition_units price_system.exhibition_units.each do |exhibition_unit|
	json.partial! 'exhibition_units/exhibition_unit', exhibition_unit: exhibition_unit
end	