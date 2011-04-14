DoomCon::Application.routes.draw do
  devise_for :users

	resources :users

	root :to => "index#index"
end
