json.extract! bill, :id, :price, :bill_type, :seq, :sign, :user_id, :created_at, :updated_at
json.url bill_url(bill, format: :json)