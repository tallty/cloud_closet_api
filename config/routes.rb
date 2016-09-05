Rails.application.routes.draw do
  resource :wechat, only: [:show, :create]
  devise_for :users

  ############ SMS Routes ###################
  resources :sms_tokens, only: [:show]  do
    collection do
      post 'register'
    end
  end
  ###########################################
end
