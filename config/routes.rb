Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :milestones, only: [:index, :show, :create, :update, :destroy] do
        collection do
          get :user_milestones
        end
        resources :comments, only: [:create, :destroy], controller: 'milestone_comments'
        resources :checkpoints, only: [:create, :destroy], controller: 'milestone_checkpoints'
      end
      resources :lists
      resources :categories, only: [:index]
      resources :users, only: [:show, :update] do
        collection do
          put :update_password
          get :me
        end
      end
    end
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  post "refresh", controller: :refresh, action: :create
  post "signin", controller: :signin, action: :create
  delete "signin", controller: :signin, action: :destroy
  post "signup", controller: :signup, action: :create

  post "password/forgot", to: "passwords#forgot"
  post "password/reset", to: "passwords#reset"
end
