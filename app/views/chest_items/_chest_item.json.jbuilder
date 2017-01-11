json.extract! chest_item, :id, :chest_id, :garment_id, :created_at, :updated_at
json.chest chest_item.chest.try(:classify_alias)
json.garment chest_item.garment.try(:title)