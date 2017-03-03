json.extract! exhibition_chest, :id, :custom_title, :title, :store_method, :max_count, :remain_space_count, 
    :need_join, :aasm_state, :state, :created_at, :updated_at
json.url exhibition_chest_url(exhibition_chest, format: :json)