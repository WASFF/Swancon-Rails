DoomCon::Application.routes.draw do
  resources :awards do
    get :nominations, on: :member
    resources :award_categories do
    end
  end

  resources :award_nominations do
    resources :award_nomination_categories do
    end
  end


#   resources :panel_suggestions do
#     get 'make_visible', on: :member
#     get 'make_invisible', on: :member
#   end

  resources :merchandise_option_sets

  resources :merchandise_types do
    post 'mark_shipped', :on => :member
    post 'add_image', :on => :member
    post 'remove_image', :on => :member
    post 'update_image_description', :on => :member
    resources :merchandise_options do
    end
  end

  resources :merchandise_sets

  resources :events do
    get 'view', on: :member
  end

  resources :vendors do
    post 'open_order', :on => :member
  end

  resources :vendor_orders do
    put 'mark_arrivals', :on => :member
    post 'close', :on => :member
  end

  resources :payments do
    post 'void', :on => :member
  end

  resources :payment_types

  resources :ticket_sets

  resources :ticket_types

  resources :member_details do
    get 'edit_my', :on => :collection
  end

  resources :launch_members do
    put 'purchase', :on => :member
    get 'viewpurchase', :on => :member
  end

  devise_for :users, :controllers => {
    omniauth_callbacks: "users/omniauth_callbacks",
    registrations: "users/registrations",
    passwords: "users/passwords"
  }


  resources :users_admin, :controller => "users" do
    get 'purchase_for', :on => :member
    get 'edit_member_details', :on => :member
  end

  resources :orders, :controller => "user_orders" do
    put 'mark_paid', :on => :member
    post 'void', on: :member
    post 'unvoid', on: :member
    post 'remail', :on => :member
  end

  resources :advertising_tags

  namespace :api do
    namespace :v1 do
      resources :members
      resources :user_order_tickets
      resources :ticket_sets, only: [:index]
      resources :merchandise_sets, only: [:index]
      resources :payment_types, only: [:index]
      resource :store, only: [], controller: "store" do
        post 'purchase'
      end
    end
  end

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  match 'tickets/my' => 'tickets#my', via: [:get]
  match 'tickets/all' => 'tickets#index', :defaults => { all: 'true' }, via: [:get]
  match 'tickets/card_issue/:id' => 'tickets#card_issue', via: :post, as: "ticket_card_issue"
  match 'tickets/card_unissue/:id' => 'tickets#card_unissue', via: :post, as: "ticket_card_unissue"
  match 'tickets/:action' => 'tickets', via: [:get, :post]
  match 'tickets/:action/:id' => 'tickets', via: [:get, :post]

  match 'seller' => 'seller#index', via: [:get]
  match 'seller/:action' => 'seller', via: [:get, :post]
  match 'seller/:action/:id' => 'seller', via: [:get, :post]

  match 'store' => 'store#index', via: [:get, :post]

  match 'store/empty_cart' => 'store#clear_cart', via: [:post]

  match 'store/ticket/:id' => 'store#ticket', via: [:get]
  match 'store/ticket/add/:id' => 'store#ticket_add', via: [:post]
  match 'store/ticket/remove/:index' => 'store#ticket_remove', via: [:post]

  match 'store/merchandise/:id' => 'store#merchandise', via: [:get]
  match 'store/merchandise/add/:id' => 'store#merchandise_add', via: [:post]
  match 'store/merchandise/remove/:index' => 'store#merchandise_remove', via: [:post]

  match 'store/purchase' => 'store#purchase', via: [:post]

  match 'programme/suggest' => 'livecon_glue#suggest', via: [:get]
  match 'programme/suggestion_accepted' => 'livecon_glue#suggestion_accepted', via: [:get]
  match 'programme/panels' => 'livecon_glue#panels', via: [:get]

  match 'promoted_items/' => 'promoted_items#index', via: [:get]
  match 'promoted_items/:action' => 'promoted_items', via: [:get]
  match 'promoted_items/:action/:id' => 'promoted_items', via: [:get]

  match '/admin' => "index#admin", as: "admin", via: [:get]
  match '/adminapp' => "index#adminapp", as: "adminapp", via: [:get]
  match '/admin/set_con_mode' => "index#set_con_mode", as: "set_con_mode", via: [:get]

  match '/track/:id' => "index#start_tracking", via: [:get], as: "tracking"

  root :to => "index#index"
end
