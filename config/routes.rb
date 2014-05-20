Mint::Application.routes.draw do
  devise_for :admins

  devise_for :users, path_prefix: 'sys'

  match 'time_records/upload' => 'time_records#upload', as: :upload_time_records
  match 'overtime_records/upload' => 'overtime_records#upload', as: :upload_overtime_records

  get 'user_time_records_feed' => 'time_records#user_feed', as: :user_time_records_feed

  get 'users(/:user_id)/time_records(/:type)' => 'users#time_records', as: :users_overall_time_records
  get 'users(/:user_id)/overtime_records(/:type)' => 'users#overtime_records', as: :users_overall_overtime_records

  match 'time_sheets/calculate' => 'time_sheets#calculate', as: :calculate_time_sheets
  post 'time_sheets' => 'time_sheets#index'

  get 'time/users' => 'time_sheets#users', as: :user_time_sheet
  get 'time/projects' => 'time_sheets#projects', as: :project_time_sheet

  get 'recorder' => 'recorder#index'

  resources :users do
    resources :projects, :time_records, :overtime_records
  end

  resources :projects do
    resources :users, :time_records
  end

  resources :projects, :users, :time_records, :roles, :user_groups, :task_types, :overtime_records, :time_sheets

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
  root :to => 'dashboard#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
