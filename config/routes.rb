Rails.application.routes.draw do
  root "dashboard#home"
  get "dashboard/home"
  get "dashboard/cycles"
  get "dashboard/employees"
  get "dashboard/reports"
  get "reviewcycles/new"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"

  resource :review_access, only: [ :show ], controller: :review_access do
    post :consume
    get :invalid
    get :confirmation
  end

  resources :review_cycles, only: [] do
    resources :review_assignments, only: [ :index ] do
      post :send_magic_link, on: :member
    end
  end

  get "/review_access/:token", to: "review_access#exchange", as: :review_access_token
end
