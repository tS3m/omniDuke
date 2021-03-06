OmniDuke::Application.routes.draw do

  devise_for :users

  root :to => 'static_pages#home'
  get '/home', to: 'static_pages#home'
  get '/courses/results', to: 'courses#results'
  get '/instructors/results', to: 'instructors#results'
  get '/subjects/results', to: 'subjects#results'
  get '/omni_results', to: 'searches#results'
  get '/subjects/instructors', to: 'subjects#show_instructors'
  get '/subjects/courses', to: 'subjects#show_courses'
  get '/schedulator/saved', to: 'schedulator#show_saved'
  get '/schedulator/classes', to: 'schedulator#show_current'
  get '/courses/side_results', to: 'courses#side_results', via: :post
  get '/schedule_relationship/replace', to: 'schedule_relationship#replace'
  get '/schedulator_saved_relationships/diverge', to: 'schedulator_saved_relationships#diverge'
  resources :courses, only: [:index, :show]
  resources :instructors, only: [:index, :show]
  resources :subjects, only: [:show, :index]
  resources :schedulator
  resources :bookbag_relationship, only: [:edit, :create, :destroy]
  resources :schedule_relationship, only: [:create, :destroy]
  resources :course_reviews, only: [:new, :index, :create]
  resources :instructor_reviews, only: [:new, :create]
  resources :schedulator_saved_relationships, only: [:create, :destroy]
  resources :active_schedulator_relationships, only: [:index, :create, :destroy]


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
