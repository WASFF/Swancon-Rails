authorization do
  role :guest do
		has_permission_on :index, :to => :index
		has_permission_on [:panel_suggestions], :to => [:show, :index]
  end
	
	role :user do
		includes :guest
		has_permission_on [:users], :to => [:update, :show, :destroy]		
		has_permission_on [:user_orders], :to => [:index, :show, :destroy]
		has_permission_on [:member_details], :to => [:edit_my, :update, :create, :show]
		has_permission_on [:panel_suggestions], :to => [:update, :create, :edit, :new]
	end

	role :member do
		includes :user
	end

	role :committee do
		includes :member
		has_permission_on :index, :to => :content_admin
		has_permission_on [:launch_members], :to => [:new, :index, :create, :edit, :update, :show, :destroy, :purchase, :viewpurchase]
		has_permission_on [:ticket_sets, :ticket_types, :payment_types, :merchandise_sets, :merchandise_types],
			:to => [:new, :index, :create, :edit, :update, :show, :destroy]
		has_permission_on [:merchandise_types], :to => [:add_image, :remove_image, :update_image_description]

		has_permission_on [:payments], :to => [:index, :show]
		has_permission_on [:users], :to => [:index, :show, :purchase_for]
		has_permission_on [:user_orders], :to => [:remail]
		
		has_permission_on [:member_details], :to => [:new, :index, :edit, :show, :destroy]

		has_permission_on [:content_blocks], :to => [:new, :index, :create, :edit, :update, :show, :preview]
		has_permission_on [:content_tags], :to => [:new, :index, :create, :edit, :update, :show]
		has_permission_on [:content_pages], :to => [:new, :index, :create, :edit, :update, :show]
		has_permission_on [:content_files], :to => [:new, :index, :create, :edit, :update, :show]
		has_permission_on [:content_images], :to => [:new, :index, :create, :edit, :update, :show]

		has_permission_on [:panel_suggestions], :to => [:destroy]
	end

	role :admin do
		includes :committee
		has_permission_on [:payments], :to => [:void]
		has_permission_on [:users], :to => [:new, :index, :create, :edit, :update, :show, :destroy]

		has_permission_on [:merchandise_types], :to => [:mark_shipped]
		has_permission_on [:merchandise_options], :to => [:new, :index, :create, :edit, :update, :show, :destroy]
		has_permission_on [:merchandise_option_sets], :to => [:new, :index, :create, :edit, :update, :show, :destroy]
			
		has_permission_on [:content_blocks], :to => [:destroy, :publish, :unpublish]
		has_permission_on [:content_files], :to => [:destroy]
		has_permission_on [:content_images], :to => [:destroy]
		
		has_permission_on [:user_orders], :to => [:mark_paid]
		has_permission_on [:payments], :to => [:void]
		has_permission_on [:vendors], :to => [:new, :index, :create, :edit, :update, :show, :destroy, :open_order]
		has_permission_on [:vendor_orders], :to => [:index, :create, :show, :destroy, :mark_arrivals, :close]
	end
end
