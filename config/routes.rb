DoomCon::Application.routes.draw do
  resources :merchandise_option_sets

  resources :merchandise_types do
		resources :merchandise_options do
		end	
	end

  resources :merchandise_sets

	resources :payments

  resources :payment_types

  resources :ticket_sets

  resources :ticket_types

  resources :launch_members do
		put 'purchase', :on => :member
		get 'viewpurchase', :on => :member
	end

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

	resources :users

	root :to => "index#index"
end
