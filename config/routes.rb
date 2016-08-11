Rails.application.routes.draw do
  get 'user/login/:uid' => 'user#login' #return user id if successful creds
  post 'user/create' => 'user#create', as: :user_create  #return user id to be local stored. Other user info postbody?
  get 'user/:id' => 'user#index', as: :user_index   #on log-in, store uid locally
  post 'user/:id' => 'user#update', as: :user_update
  post 'user/:id/approved/:upc' => 'user#approved', as: :user_approved#every time post, store return locally for immediate use
  post 'user/:id/avoid/:avoid' => 'user#avoid', as: :user_avoid #every time post, store return locally for immediate use
  get 'user/:id/products' => 'user#products' #return list of manufactrers contacted by user INCOMPLETE
  post 'user/:id/:upc/' => 'user#contact_manufacturer' #unknown if will use. May do direct API call in app, and use this to track in database
  get 'test' => 'ingredients#test'

  get '/ingredients/:upc/:id' => 'ingredients#lookup'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
