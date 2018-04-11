Rails.application.routes.draw do

  devise_scope :user do
    authenticated :user do
      root 'pages#home', as: :authenticated_root
    end
    unauthenticated do
      root 'devise/sessions#new', as: :unauthenticated_root
    end
  end

  devise_for :users, :controllers => { :sessions => 'sessions' }

  namespace :admin do
    resources :users
    resources :projects
    post 'project_tasks' => "projects#project_tasks", as: :project_tasks
    post 'project_categories' => "projects#project_categories", as: :project_categories
    resources :categories
    resources :tasks
    post "update_schedule" => "schedules#update", as: :update_schedule
    resources :calendar_parameters, only: [:edit, :update]
    post "time_entries/:id" => "time_entries#update", as: :update_time_entry
    resources :time_entries

    post 'export-time-entries' => 'exports#time_entries'
  end
end
