Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :users
      resources :projects
      post '/login', to: "sessions#create"
      post '/profile/photo/update', to: "users#upadate_profile_photo"
    end
  end
end
