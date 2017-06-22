json.extract! exhibition_chest, :id, :title, :store_method, 
	:max_space_count, :be_token_space_count, :remain_space_count, :it_has_space,
  :need_join, :aasm_state, :state
json.custom_title exhibition_chest.custom_title || exhibition_chest.title
json.url exhibition_chest_url(exhibition_chest, format: :json)
json.max_count exhibition_chest.max_space_count