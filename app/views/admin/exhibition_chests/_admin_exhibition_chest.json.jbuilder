json.extract! exhibition_chest, :id, :title, :store_method, :it_has_space,
  :need_join, :aasm_state, :state, :expire_time, :is_expired, :is_about_to_expire
json.max_count exhibition_chest.max_space_count_alone
json.be_token_space_count exhibition_chest.be_token_space_count_alone
json.remain_space_count exhibition_chest.remain_space_count_alone