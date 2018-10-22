Rails.application.routes.draw do
  root 'pages#home'


  devise_for :users, :controllers => { :sessions => 'sessions' }

  namespace :admin do
    resources :users
    resources :projects do
      get :kanban, on: :member
    end
    post 'project-tasks' => "projects#project_tasks", as: :project_tasks
    post 'project-categories' => "projects#project_categories", as: :project_categories
    post 'toggle-in-pause' => 'projects#toggle_in_pause'

    resources :categories, except: [:index, :show]
    post 'toggle-hidden-categories' => 'categories#toggle_hidden'
    post 'update-tasks-categories' => 'categories#update_tasks_category'

    resources :kanban_states

    resources :tasks
    post "task-project" => "tasks#get_project", as: :get_project
    get "task-modal" => "tasks#show_modal", as: :show_modal

    post "update_schedule" => "schedules#update", as: :update_schedule
    resources :calendar_parameters, only: [:edit, :update]
    post "time_entries/:id" => "time_entries#update", as: :update_time_entry
    resources :time_entries

    post 'export-time-entries' => 'exports#time_entries'

    resources :comments
  end
end
