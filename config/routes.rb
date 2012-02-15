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


	resources :panel_suggestions

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

	devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks", :registrations => "registrations" }

	resources :users_admin, :controller => "users" do
		get 'purchase_for', :on => :member
	end
	
	resources :orders, :controller => "user_orders" do
		put 'mark_paid', :on => :member
		post 'remail', :on => :member		
	end

	# Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action
  
	match 'seller' => 'seller#index'
  	match 'seller/:action' => 'seller'
	match 'seller/:action/:id' => 'seller'
	
	match 'store' => 'store#index'
	
	match 'store/empty_cart' => 'store#clear_cart'

	match 'store/ticket/:id' => 'store#ticket'
	match 'store/ticket/add/:id' => 'store#ticket_add'
	match 'store/ticket/remove/:index' => 'store#ticket_remove'

	match 'store/merchandise/:id' => 'store#merchandise'
	match 'store/merchandise/add/:id' => 'store#merchandise_add'
	match 'store/merchandise/remove/:index' => 'store#merchandise_remove'

	match 'store/purchase' => 'store#purchase'

	root :to => "content_viewer#homepage"
end
