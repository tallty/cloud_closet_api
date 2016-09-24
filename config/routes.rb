Rails.application.routes.draw do
  devise_for :users

  ############ SMS Routes ###################
  resources :sms_tokens, only: [:show]  do
    collection do
      post 'register'
    end
  end
  ###########################################


  ############ UserInfo Routes ###################
  resource :user_info, only: [:show, :update]
  ###############################################
end
