# frozen_string_literal: true

Rails.application.routes.draw do
  scope Rails.application.config.relative_url_root || '/' do
    resources :participations, only: %i[index new create]

    namespace :admin do
      resource :logins, only: %i[new create destroy]
      resources :log_entries, only: :index
      resources :participations, only: %i[index edit update]
      resources :users
      root 'participations#index'
    end
    root 'participations#new'
  end
end
