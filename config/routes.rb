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

  ############ Garment Routes ###################
  resources :garments, only: [:index, :show]
  ###############################################  

  ############ Appointment Routes ###################
  resources :appointments, only: [:create, :index, :show]
  ###############################################    
end
