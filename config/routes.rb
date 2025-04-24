Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :milestones, only: [ :index, :show, :create, :update, :destroy ] do
        collection do
          get :from_user
          get :from_friends
          get :popular
          get :recommendations
        end
        member do
          post :clone
        end
        resources :comments, only: [ :create, :destroy ], controller: "milestone_comments"
        resources :checkpoints, only: [ :create, :destroy, :update ], controller: "milestone_checkpoints"
      end
      resources :lists do
        member do
          post :add_milestone
        end
      end
      resources :categories, only: [ :index ]
      resources :users, only: [ :show, :update ] do
        collection do
          put :update_password
          get :me
        end
      end

      resources :milestone_completions, only: [:show, :create]
      resources :friendships, param: :friend_id, only: [:index, :show, :create, :update, :destroy] do
        collection do
          get :pending
          get :sent
          get :possible
          get :recommended
        end
      end
      
      get '/milestone-share/:id', to: 'share#milestone'
    end
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  get "/" => "rails/health#show"

  post "refresh", controller: :refresh, action: :create
  post "signin", controller: :signin, action: :create
  delete "signin", controller: :signin, action: :destroy
  post "signup", controller: :signup, action: :create

  post "password/forgot", to: "passwords#forgot"
  post "password/reset", to: "passwords#reset"
end
