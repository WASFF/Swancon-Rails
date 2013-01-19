authorization do
  role :guest do
		has_permission_on :index, :to => :index
		has_permission_on [:panel_suggestions], :to => [:show, :index, :new, :create]
		has_permission_on [:award_nomination], to: [:new, :index, :create, :edit, :update, :show]
  end
	
	role :user do
		includes :guest
		has_permission_on [:user_orders], :to => [:index, :show, :void, :unvoid]
		has_permission_on [:member_details], :to => [:edit_my, :update, :create]
		has_permission_on [:panel_suggestions], :to => [:update, :create, :edit, :new]
		has_permission_on [:tickets], :to => [:transfer, :find_user, :confirm_transfer, :reconfirm_transfer, :my]
	end

	role :member do
		includes :user
	end

	role :"ticket seller" do
		has_permission_on [:member_details], :to => [:new, :create]
		has_permission_on :user_orders, to: [:show]
		has_permission_on :seller, to: [:index, :select, :create, :clear, :sales]
	end

	role :committee do
		includes :member
		includes :"ticket seller"
		has_permission_on [:tickets], 
			:to => [:index, :export_badges, :export_salesdata, 
					:card_issue, :card_unissue]
		has_permission_on [:ticket_sets, :ticket_types, :payment_types, :merchandise_sets, :merchandise_types],
			:to => [:new, :index, :create, :edit, :update, :show, :destroy]
		has_permission_on [:merchandise_types], :to => [:add_image, :remove_image, :update_image_description]

		has_permission_on [:payments], :to => [:index, :show]
		has_permission_on [:users], :to => [:index, :show, :purchase_for, :edit_member_details]
		has_permission_on [:user_orders], :to => [:remail]
		
		has_permission_on [:member_details], :to => [:new, :index, :edit, :show, :destroy]

		has_permission_on [:content_blocks], :to => [:new, :index, :create, :edit, :update, :show, :preview]
		has_permission_on [:content_tags], :to => [:new, :index, :create, :edit, :update, :show]
		has_permission_on [:content_pages], :to => [:new, :index, :create, :edit, :update, :show]
		has_permission_on [:content_files], :to => [:new, :index, :create, :edit, :update, :show]
		has_permission_on [:content_images], :to => [:new, :index, :create, :edit, :update, :show]
		has_permission_on [:panel_suggestions], :to => [:destroy, :make_visible, :make_invisible]
		has_permission_on [:promoted_items], :to => [:index, :form_save]
	end

	role :"awards administrator" do
		has_permission_on [:awards, :award_categories], to: [:new, :index, :create, :edit, :update, :show, :destroy]
		has_permission_on [:awards], to: [:nominations]
	end

	role :admin do
		includes :committee
		has_permission_on [:payments], :to => [:void]
		has_permission_on [:users], :to => [:new, :index, :create, :edit, :update, :show, :destroy]

		has_permission_on [:merchandise_types], :to => [:mark_shipped]
		has_permission_on [:merchandise_options], :to => [:new, :index, :create, :edit, :update, :show, :destroy]
		has_permission_on [:merchandise_option_sets], :to => [:new, :index, :create, :edit, :update, :show, :destroy]
			
		has_permission_on [:content_pages], :to => [:destroy]
		has_permission_on [:content_blocks], :to => [:destroy, :publish, :unpublish]
		has_permission_on [:content_files], :to => [:destroy]
		has_permission_on [:content_images], :to => [:destroy]
		
		has_permission_on [:user_orders], :to => [:mark_paid]
		has_permission_on [:payments], :to => [:void]
		has_permission_on [:vendors], :to => [:new, :index, :create, :edit, :update, :show, :destroy, :open_order]
		has_permission_on [:vendor_orders], :to => [:index, :create, :show, :destroy, :mark_arrivals, :close]
		has_permission_on [:tickets], :to => [:cancel_transfer, :export]
	end
end
