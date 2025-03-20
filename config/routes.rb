Rails.application.routes.draw do
  get "home/index"
  devise_for :people, skip: [:registrations]
  resources :grades do
    collection do
      get 'students_for_examination/:examination_id', action: :students_for_examination, as: :students_for_examination
    end
  end
  resources :examinations do
    member do
      get 'students'
    end
  end
  resources :courses
  resources :school_classes do
    member do
      get 'manage_students'
      post 'update_students'
    end
  end
  resources :subjects
  resources :promotion_asserts
  resources :moments
  resources :sectors
  resources :people
  resources :statuses do
    collection do
      get :search
    end
  end
  resources :rooms
  resources :addresses do
    collection do
      get :search
    end
  end
  resources :reports, only: [:index]
  
  # Deleted objects management routes
  resources :deleted_objects, only: [:index] do
    member do
      patch :restore, to: 'deleted_objects#restore'
    end
    collection do
      patch :restore, to: 'deleted_objects#restore', as: :restore_deleted_object
      patch :restore_all, to: 'deleted_objects#restore_all', as: :restore_all_deleted_objects
    end
  end
  
  root "home#index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
