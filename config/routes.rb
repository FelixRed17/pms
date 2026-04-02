Rails.application.routes.draw do
  root "dashboard#cycles"
  get "dashboard/home"
  get "dashboard/cycles"
  get "dashboard/employees"
  get "dashboard/reports"
  get "reviewcycles/new"
  get "login" => "sessions#new"
  post "reviewcycles", to: "reviewcycles#create", as: :reviewcycles
  resources :review_cycles, path: "reviewcycles", controller: "reviewcycles", only: [] do
    resources :review_assignments, path: "assignments", only: :index do
      post :send_magic_link, on: :member
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"

  get "/review_access/invalid", to: "review_access#invalid", as: :invalid_review_access
  get "/review_access/confirmation", to: "review_access#confirmation", as: :confirmation_review_access
  get "/review_access/:token", to: "review_access#show", as: :review_access
  post "/review_access/:token/submit", to: "review_access#submit", as: :submit_review_access
  post "/review_access/consume", to: "review_access#consume", as: :consume_review_access
  post "/review_requests/:id/reissue", to: "review_requests#reissue", as: :reissue_review_request
end
