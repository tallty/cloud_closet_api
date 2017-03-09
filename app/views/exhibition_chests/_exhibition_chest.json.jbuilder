json.extract! exhibition_chest, :id, :custom_title, :title, :store_method, 
	:max_space_count, :be_token_space_count, :remain_space_count, :it_has_space,
  :need_join, :aasm_state, :state, :created_at, :updated_at
json.url exhibition_chest_url(exhibition_chest, format: :json)
json.max_count exhibition_chest.max_space_count