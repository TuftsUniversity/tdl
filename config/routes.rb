ALLOW_DOTS ||= /[a-zA-Z0-9_.:]+/

TDL::Application.routes.draw do
  root :to => "catalog#index"

  match '/imageviewer/:id', :to => 'imageviewer#show', :constraints => {:id => /.*/}, :as =>'imageviewer'

  Blacklight.add_routes(self)
    resources :catalog, :only => [:show, :update], :constraints => { :id => ALLOW_DOTS, :format => false }
    Blacklight::Routes.new(self, {}).catalog
    resources :unpublished, :only => :index
    # This is from Blacklight::Routes#solr_document, but with the constraints added which allows periods in the id
    resources :solr_document,  :path => 'catalog', :controller => 'catalog', :only => [:show, :update]
    resources :downloads, :only =>[:show], :constraints => { :id => ALLOW_DOTS
   }
   resources :bookmarks, :path => 'catalog'
   resources :search_history, :path => 'search_history', :only => [:index,:show]

    HydraHead.add_routes(self)
   match "/about" => "about#index"
   match "/contact" => "contact#show"
   match "/about/:action" => "about"
   match '/file_assets/medium/:id', :to => 'local_file_assets#showMedium', :constraints => {:id => /.*/}, :as =>'file_asset'
   match '/file_assets/advanced/:id', :to => 'local_file_assets#showAdvanced', :constraints => {:id => /.*/}, :as =>'file_asset'
   match '/file_assets/thumb/:id', :to => 'local_file_assets#showThumb', :constraints => {:id => /.*/}, :as =>'file_asset'
   match '/file_assets/transcript/:id', :to => 'local_file_assets#showTranscript', :constraints => {:id => /.*/}, :as =>'file_asset'
   match '/file_assets/rcr/:id', :to => 'local_file_assets#showRCR', :constraints => {:id => /.*/}, :as =>'file_asset'
   match '/file_assets/generic/:id/:index', :to => 'local_file_assets#showGeneric', :constraints => {:id => /.*/}, :as =>'file_asset'
   match '/file_assets/dimensions/:id', :to => 'local_file_assets#dimensions', :constraints => {:id => /.*/}, :as =>'file_asset'
   match '/file_assets/image_overlay/:id', :to => 'local_file_assets#image_overlay', :constraints => {:id => /.*/}, :as =>'file_asset'
   match '/file_assets/image_gallery/:id/:start/:number', :to => 'local_file_assets#image_gallery', :constraints => {:id => /.*/}, :as =>'file_asset'
   match '/file_assets/ogg/:id', :to => 'local_file_assets#showOGG', :constraints => {:id => /.*/}, :as =>'file_asset'
   match '/local_file_assets/:id', :to => 'local_file_assets#show', :constraints => {:id => /.*/}, :as =>'file_asset'
   match '/file_assets/:id', :to => 'local_file_assets#show', :constraints => {:id => /.*/}, :as =>'file_asset'

  devise_for :users


  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
