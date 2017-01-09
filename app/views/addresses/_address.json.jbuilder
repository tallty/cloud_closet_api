json.extract! address, :id, :name, :address_detail, :phone, :is_default, :house_number, :sex, :created_at, :updated_at
json.url address_url(address, format: :json)