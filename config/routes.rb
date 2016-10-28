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

  ####################Bill Routes#######################
  resources :bills, only: [:show, :index, :create] do
    collection do
      get :deposit_bill
      get :payment_bill
    end
  end

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


  ############ Work Routes ############################ 
  namespace :work do
    resources :appointments, only: [:index, :show, :destroy, :update]
    resources :price_systems, only: [:index, :show]
  end
  ######################################################## 

  ############ Admin Routes ###############################
  namespace :admin do
    resources :appointments, only: [:index, :show] do
      resources :appointment_item_groups, only: [:index]
    end
    resources :appointment_item_groups, only: [:show] do
      resources :garments, only: [:index]
    end
    resources :garments, only: [:update, :show]
    resources :price_systems
  end
  #########################################################

  ############ Address Routes ##############################
  resources :addresses, only: [:index, :create,:update, :destroy] do
    post 'set_default', on: :member
  end
  ###########################################################   

  ############ PurchaseLog Routes #########################
  resources :purchase_logs, only: [:index,:show]
  #####################################################

end
