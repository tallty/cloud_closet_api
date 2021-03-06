Rails.application.routes.draw do
  devise_for :workers
  devise_for :admins
  devise_for :users, controllers: { registrations: "users_registrations"}

  # ------------ SMS Routes ------------------#
  resources :sms_tokens, only: [:show]  do
    collection do
      post 'register'
    end
  end
  # ------------------------------------------#

  resources :invoices, only: [:show, :index, :create]

  # ------------ UserInfo Routes ------------------#
  resource :user_info, only: [:show, :update] do
    member do
      post :bind
      post :check_openid
    end
  end
  # ----------------------------------------------#

  # ------------ 消息中心 Routes ------------------#
  get 'user_msg_center', to: 'user_msg_center#user_msg_center'
  resources :user_msgs, only: [:show, :index]
  resources :public_msgs, only: [:show]
  namespace :admin do 
    resources :public_msgs
  end
  # ----------------------------------------------#

  # ------------ Garment Routes ------------------#
  resources :garments, only: [:index, :show, :update] do 
    collection do 
      post :add_them_to_basket
      post :get_out_of_basket
      get :basket
      get :select_by_tags
    end
  end
  # ----------------------------------------------#  

  # ------------ 配送 Routes ------------------#
  resources :delivery_orders do 
    member do 
      post :pay
      post :get_home
    end
  end

  namespace :admin do 
    resources :delivery_orders do 
      member do
        post :send_out
        post :cancel
      end
    end
  end
  # ----------------------------------------------#   


   # ------------ ExhibitionChest Routes ------------------#
  resources :exhibition_chests, only: [:index, :show, :update] do 
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
    resources :offline_recharges, only: [:index, :show, :create] do
      collection do
        post 'get_auth_code'
      end 
    end
    resources :price_systems, only: [:index, :show]
  end
  # -------------------------------------------------------- 

  # ------------ Admin Routes ------------------------------#
  namespace :admin do
    resources :appointments do
      member do 
        post 'stored'
        post 'cancel'
        post 'recover'
        get 'its_chests'
      end
    end
 
    resources :offline_recharges, only: [:index, :show] do 
      member do 
        post 'to_confirmed_or_not'
      end
    end
       
    resources :users, only: [:index, :show] do
      resources :delivery_orders, only: :index
      resources :exhibition_chests, only: :index
      resources :service_orders, only: [:index, :create]
      resources :appointments, only: :create
    end

    resources :service_orders, only: [:index, :show]

    resources :exhibition_chests do 
      member do 
        post 'release'
        post 'lease_renewal'
      end
      resources :garments
    end

    resources :garments, only: [:update, :show, :destroy]

    resources :price_systems do 
      resources :exhibition_units
    end
    resources :constant_tags
    resources :invoices, only: [:show, :index] do 
      member do 
        post :accept
        # post :refuse
        # post :send_out
      end
    end
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
