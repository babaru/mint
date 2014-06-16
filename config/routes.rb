Mint::Application.routes.draw do

  get 'me' => 'time_recorder#index', as: :personal_time_recorder
  get 'leave' => 'leave_recorder#index', as: :leave_time_recorder
  get 'overtime' => 'overtime_recorder#index', as: :overtime_recorder

  devise_for :users, path_prefix: 'sys'

  scope '/manager' do
    get 'dashboard' => 'dashboard#index', as: :dashboard

    match 'time_records/upload' => 'time_records#upload', as: :upload_time_records
    match 'overtime_records/upload' => 'overtime_records#upload', as: :upload_overtime_records
    match 'leave_records/upload' => 'leave_records#upload', as: :upload_leave_records

    get 'users(/:user_id)/time_records(/:type)' => 'users#time_records', as: :users_overall_time_records
    get 'users(/:user_id)/overtime_records(/:type)' => 'users#overtime_records', as: :users_overall_overtime_records

    match 'time_sheets/calculate' => 'time_sheets#calculate', as: :calculate_time_sheets
    post 'time_sheets' => 'time_sheets#index'

    get 'time/report' => 'time_sheets#index', as: :time_report
    post 'time/query_by_duration' => 'time_sheets#query_by_duration', as: :query_time_report_by_duration

    resources :users do
      resources :projects, :time_records, :overtime_records
    end

    resources :projects do
      resources :users, :time_records, :project_logs
    end

    resources :clients, :projects, :users, :time_records, :roles, :user_groups, :task_types, :overtime_records, :time_sheets, :project_logs

  end

  get 'user_time_records_feed' => 'time_records#user_feed', as: :user_time_records_feed
  get 'user_leave_records_feed' => 'leave_records#user_feed', as: :user_leave_records_feed
  get 'user_overtime_records_feed' => 'overtime_records#user_feed', as: :user_overtime_records_feed

  resources :time_records, :leave_records, :overtime_records # TODO use api gem

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
  root :to => 'time_recorder#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  match ':controller(/:action(/:id))(.:format)'
end
