json.extract! exhibition_chest, :id, :title, :store_method, :it_has_space,
  :need_join, :aasm_state, :state, :created_at, :updated_at
json.max_count exhibition_chest.max_space_count_alone
json.be_token_space_count exhibition_chest.be_token_space_count_alone
json.remain_space_count exhibition_chest.remain_space_count_alone