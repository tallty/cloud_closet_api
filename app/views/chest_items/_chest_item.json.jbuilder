json.extract! chest_item, :id, :chest_id, :appointment_item_id, :created_at, :updated_at
json.chest chest_item.chest.try(:classify_alias)
json.url chest_item_url(chest_item, format: :json)