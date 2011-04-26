authorization do
  role :guest do
		has_permission_on :index, :to => :index
  end
	
	role :user do
		includes :guest
		has_permission_on [:users], :to => [:update, :show, :destroy]		
	end

	role :member do
		includes :user
	end

	role :committee do
		includes :member
		has_permission_on :index, :to => :content_admin
		has_permission_on [:launch_members], :to => [:new, :index, :create, :edit, :update, :show, :destroy, :purchase, :viewpurchase]
		has_permission_on [:ticket_sets, :ticket_types, :payment_types, :merchandise_sets, :merchandise_types, :payments],
			:to => [:new, :index, :create, :edit, :update, :show, :destroy]
		has_permission_on [:users], :to => [:new, :index, :create, :edit, :update, :show, :destroy]
		has_permission_on [:content_blocks], :to => [:new, :index, :create, :edit, :update, :show, :preview]
		has_permission_on [:content_tags], :to => [:new, :index, :create, :edit, :update, :show]
		has_permission_on [:content_pages], :to => [:new, :index, :create, :edit, :update, :show]
	end

	role :admin do
		includes :committee
		has_permission_on [:users], :to => [:new, :index, :create, :edit, :update, :show, :destroy]
		has_permission_on [:content_blocks], :to => [:new, :index, :create, :edit, :update, :show, :destroy, :preview, :publish, :unpublish]
	end
end
