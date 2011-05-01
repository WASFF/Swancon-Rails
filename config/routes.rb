DoomCon::Application.routes.draw do
  resources :member_details

  resources :merchandise_option_sets

  resources :merchandise_types do
		resources :merchandise_options do
		end	
	end

  resources :merchandise_sets

	resources :payments do
		post 'void', :on => :member
	end

  resources :payment_types

  resources :ticket_sets

  resources :ticket_types

  resources :launch_members do
		put 'purchase', :on => :member
		get 'viewpurchase', :on => :member
	end

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

	resources :users
	
	resources :orders, :controller => "user_orders" do
		put 'mark_paid', :on => :member
	end

	# Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action
  
	match 'store' => 'store#index'

	match 'store/ticket/:id' => 'store#ticket'
	match 'store/ticket/add/:id' => 'store#ticket_add'
	match 'store/ticket/remove/:index' => 'store#ticket_remove'

	match 'store/merchandise/:id' => 'store#merchandise'
	match 'store/merchandise/add/:id' => 'store#merchandise_add'
	match 'store/merchandise/remove/:index' => 'store#merchandise_remove'

	match 'store/purchase' => 'store#purchase'

	root :to => "index#index"
end
