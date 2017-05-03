json.extract! exhibition_chest, :id, :title, :store_method, 
  :remain_space_count, :it_has_space,
  :need_join, :aasm_state, :state, :created_at, :updated_at
json.max_space_count exhibition_chest.max_count
json.be_token_space_count exhibition_chest.garments.count
json.custom_title exhibition_chest.custom_title || exhibition_chest.title
json.url exhibition_chest_url(exhibition_chest, format: :json)
json.max_count exhibition_chest.max_space_count