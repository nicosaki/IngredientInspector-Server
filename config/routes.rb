Rails.application.routes.draw do
  get 'user/login' => 'user#login' #return user id if successful creds
  post 'user/create' => 'user#create', as: :user_create  #return user id to be local stored
  get 'user/:id' => 'user#index', as: :user_index   #on log-in, store uid locally
  post 'user/:id/approved' => 'user#approved', as: :user_approved
  post 'user/:id/avoid' => 'user#avoid', as: :user_avoid
  get 'user/:id/manufacturers' => 'user#manufacturers' #return list of manufactrers contacted by user
  post 'user/:id/manufacturers/' => 'user#contact_manufacturer' #unknown if will use. May do direct API call in app, and use this to track in database


  get '/ingredients/:upc' => 'ingredients#lookup'

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
