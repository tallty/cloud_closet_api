Rails.application.routes.draw do
  devise_for :workers
  devise_for :admins
  devise_for :users

  # ------------ SMS Routes ------------------#
  resources :sms_tokens, only: [:show]  do
    collection do
      post 'register'
    end
  end
  # ------------------------------------------#

  # --------------------Bill Routes----------------------#
  resources :bills, only: [:show, :index, :create] do
    collection do
      get :deposit_bill
      get :payment_bill
    end
  end

  # ------------ UserInfo Routes ------------------#
  resource :user_info, only: [:show, :update] do
    member do
      post :bind
      post :check_openid
    end
  end
  # ----------------------------------------------#

  # ------------ Garment Routes ------------------#
  resources :garments, only: [:index, :show, :update]
  # ----------------------------------------------#  

   # ------------ ExhibitionChest Routes ------------------#
  resources :exhibition_chests, only: [:index, :show] do 
    member do 
      post 'move_garment' #----!
      post 'delete_his_val_chest'
      get 'the_same_store_method'
    end
  end

  # ----------------------------------------------#
 
  # ------------ Appointment Routes ------------------#
  resources :appointments, only: [:create, :index, :show] do
    post 'cancel', on: :member
    post 'pay_by_balance', on: :member
    resources :appointment_item_groups, only: [:index]
  end
  resources :appointment_item_groups, only: [:show] do
    resources :garments, only: [:index]
  end
  # ----------------------------------------------#    
  # user price_systems
  resources :price_systems, only: [:index, :show]

  # ------------ Worker Routes ---------------------------- 
  namespace :worker do
    resources :appointments, only: [:index, :show, :destroy, :update] do
      member do
        post 'accept'
        post 'storing'
        post 'cancel'
      end
      get 'state_query', on: :collection
    end    
    resources :offline_recharges, only: [:index, :show, :create]
    resources :price_systems, only: [:index, :show]
  end
  # -------------------------------------------------------- 

  # ------------ Admin Routes ------------------------------#
  namespace :admin do
    resources :appointments, only: [:index, :show] do
      member do 
        post 'stored'
        get 'its_chests'
      end
    end

    resources :offline_recharges, only: [:index, :show] do 
      member do 
        post 'to_confirmed_or_not'
      end
    end

    resources :exhibition_chests do 
      member do 
        post 'release'
      end
      resources :garments
    end
    resources :garments, only: [:update, :show, :destroy]
    resources :price_systems do 
      resources :exhibition_units
    end
    resources :constant_tags
  end
  # --------------------------------------------------------#

  # ------------ Address Routes ------------------------------
  resources :addresses, only: [:index, :show, :create,:update, :destroy] do
    post 'set_default', on: :member
  end
  # ----------------------------------------------------------#   

  # ------------ RechargeRule Routes ------------------------#
  resources :recharge_rules, only: [:index,:show]
  # ----------------------------------------------------#

  # ------------ ConstantTag Routes ------------------------#
  # 得到所有固定标签
  resources :constant_tags, only: [:index, :show]
  # ----------------------------------------------------#
  ##
  # ------------ PurchaseLog Routes ------------------------#
  resources :purchase_logs, only: [:index,:show]
  # ----------------------------------------------------#

  # ------------# Pingpp Routes --------------------------#
  post 'get_pingpp_pay_order', to: 'pingpp#get_pay_order'
  post 'get_pingpp_webhooks', to: 'pingpp#get_pingpp_webhooks'
  # ----------------------------------------------------#
  
  # ---------------- QueryAppointments Routes ----------------
  get 'query_appointments', to: 'query_appointments#query_appointments'
  # ------------------------------------------------------------

  # ---------------- QueryPriceSystems Routes ----------------
  get 'query_price_systems', to: 'query_price_systems#query_price_systems'
  # ------------------------------------------------------------
  
end
