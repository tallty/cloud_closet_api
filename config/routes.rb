Rails.application.routes.draw do
  devise_for :admins
  devise_for :users

  ############ SMS Routes ###################
  resources :sms_tokens, only: [:show]  do
    collection do
      post 'register'
    end
  end
  ###########################################


  ############ UserInfo Routes ###################
  resource :user_info, only: [:show, :update] do
    member do
      post :bind
      post :check_openid
    end
  end
  ###############################################

  ############ Garment Routes ###################
  resources :garments, only: [:index, :show]
  ###############################################  

  ############ Appointment Routes ###################
  resources :appointments, only: [:create, :index, :show] do
    resources :appointment_item_groups, only: [:index]
  end
  resources :appointment_item_groups, only: [:show] do
    resources :garments, only: [:index]
  end
  ###############################################    


  ############ Work Routes ###################
  namespace :work do
    resources :appointments, only: [:index, :show] do
      resources :appointment_item_groups, only: [:index, :create]
    end
    resources :appointment_item_groups, only: [:show, :update, :destroy]
  end
  ###############################################    

  ############ Admin Routes ###################
  namespace :admin do
    resources :appointments, only: [:index, :show] do
      resources :appointment_item_groups, only: [:index]
    end
    resources :appointment_item_groups, only: [:show] do
      resources :garments, only: [:index]
    end
    resources :garments, only: [:update, :show]
  end
  ###############################################    
end
