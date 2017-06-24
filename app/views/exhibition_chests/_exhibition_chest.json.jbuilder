json.extract! exhibition_chest, :id, :title, :store_method, 
	:max_space_count, :be_token_space_count, :remain_space_count, :it_has_space,
  :need_join, :aasm_state, :state, :custom_title
json.expire_time exhibition_chest.expire_time.strftime('%Y-%m-%d %H:%M')
json.max_count exhibition_chest.max_space_count