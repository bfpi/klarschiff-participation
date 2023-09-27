# frozen_string_literal: true

Rails.application.routes.draw do
  scope Rails.application.config.relative_url_root || '/' do
    resource :logins, only: %i[new create destroy]
    resources :participations, only: %i[new create]

    namespace :admin do
      resources :participations, only: %i[index show]
      root 'participations#index'
    end
    root 'participations#new'
  end
end
