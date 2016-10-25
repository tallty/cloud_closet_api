json.extract! address, :id, :name, :address_detail, :phone, :default?, :created_at, :updated_at
json.url address_url(address, format: :json)