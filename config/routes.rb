Rails.application.routes.draw do

  devise_scope :user do
    authenticated :user do
      root 'pages#home', as: :authenticated_root
    end
    unauthenticated do
      root 'devise/sessions#new', as: :unauthenticated_root
    end
  end

  devise_for :users

  namespace :admin do
    resources :users
    resources :projects
    resources :tasks
    post "update_schedule" => "schedules#update", as: :update_schedule
    resources :calendar_parameters, only: [:edit, :update]
    resources :time_entries

    post 'export-time-entries' => 'exports#time_entries'
  end
end
