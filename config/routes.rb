Rails.application.routes.draw do
  devise_for :users
  get 'clients/new'

  resources :teams, only: [:index, :show]
  resources :events, only: [:index, :show]
  resources :specialofficers, only: [:index, :show]
  match 'contact', to: 'contact#new', via: :get
  match 'contact', to: 'contact#create', via: :post
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'home#index'
  get 'admin/' => 'admin/administrations#index'
  namespace :admin do
    resources :administrations
    resources :teams
    resources :events
  end
  # Example of regular route:
  get 'haircut' => 'home#haircut'
  get 'haircolor' => 'home#haircolor'
  get 'hairtreatment' => 'home#hairtreatment'
  get 'hairrituals' => 'home#hairrituals'
  get 'aboutus' => 'home#aboutus'
  get 'gallery' => 'home#gallery'
  get 'products' => 'home#products'

  get 'specialoffers' => 'home#specialoffers'

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
