Links::Application.routes.draw do
  root to: "sessions#new"

  resources :wizards, only: [:new, :create]
  resource :session, only: [:new, :create, :destroy]
  resources :courses
  resources :enrollments, only: [:create, :destroy]
end
