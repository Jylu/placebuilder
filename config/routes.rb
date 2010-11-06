ActionController::Routing::Routes.draw do |map|

  map.with_options :conditions => { :subdomain => "admin" } do |admin|
    admin.root :controller => "administration", :action => "show"
    
    admin.resources :addresses, :controller => "administration/addresses"
    admin.resources :organizations, :controller => "administration/organizations"
    admin.resources :deliveries
  end
  
  map.with_options :conditions => { :subdomain => /[A-Za-z]+/ }, :shallow => true do |community|
    
    community.resources :avatars, :only => [:edit, :update]
    
    community.root :controller => "communities", :action => "show"

    community.resources :posts
    community.resources :first_posts, :only => [:create,:new]
    
    community.resources :announcements, :collection => {"subscribed" => :get}
    community.resources :subscriptions, :collection => {"recommended" => :get}
    community.resources :replies
    
    community.resources :tags
    
    community.resources :events, :collection => {"your" => :get, "suggested" => :get} do |event|
      event.resource :attendance
      event.resources :referrals
      event.resources :messages, :only => [:create, :new], :requirements => {:messagable => "Event"}
    end
    
    community.resources :users do |user|
      user.resource :met, :only => [:create]
      user.resources :messages, :only => [:create, :new], :requirements => {:messagable => "User"}
    end
    
    community.resources :invites
    
    community.resources(:organizations, 
                        :collection => {
                          "municipal" => :get, 
                          "business" => :get,
                          "organization" => :get
                        }) do |org|
      org.resource :subscription, :only => [:index, :show, :create, :destroy]
      org.resource :claim, :member => [:edit_fields]
      org.resources :announcements, :controller => "organizations/announcements"
      org.resources :profile_fields, :collection => {"order" => :put}
      org.resources :messages, :only => [:create, :new], :requirements => {:messagable => "Organization"}
    end

    community.namespace :neighborhood do |neighborhood|
      neighborhood.resources :people, :only => :index
    end

    map.about 'about', :controller => 'site', :action => 'about'
    map.privacy 'privacy', :controller => 'site', :action => 'privacy'
    map.terms 'terms', :controller => 'site', :action => 'terms'
    map.dmca 'dmca', :controller => 'site', :action => 'dmca'
    map.logout 'logout', :controller => 'user_sessions', :action => 'destroy'
    map.login 'get-started', :controller => 'user_sessions', :action => 'new'
    
    map.resource :inbox
    map.resources :platform_updates
    map.resources :conversations
    
    map.resource :user_session
    map.resources :password_resets
    
    map.resource :account, :member => { :more_info => :get }
    map.resources :mets
    map.resource :management, :controller => 'management'

    map.namespace :management do |man|
      man.resources :organizations, :member => [:outreach]do |org|
        org.resources :announcements, :controller => 'organizations/announcements'
        org.resources :events, :controller => 'organizations/events'
        org.resources :profile_fields, :controller => 'organizations/profile_fields', :collection => {:order => :post}
      end
      man.resources :events, :member => [:conversation, :replies, :outreach]
      man.resources :invites
      man.resources :email_invites
    end

    map.profile ':id', :controller => 'organizations', :action => 'profile', :conditions => { :method => :get }
    
  end
  
  
  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
  
end
