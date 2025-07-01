# frozen_string_literal: true

Rails.application.routes.draw do
  scope Rails.application.config.relative_url_root || '/' do
    resources :participations, only: %i[index new create]

    namespace :joining do
      get ':activity_token/new' => :new, as: :new
      get ':activity_token/confirm' => :confirm, as: :confirm
      get ':activity_token/reject' => :reject, as: :reject
      patch :create
    end

    namespace :withdrawal do
      get ':activity_token/new' => :new, as: :new
      get ':activity_token/confirm' => :confirm, as: :confirm
      get ':activity_token/reject' => :reject, as: :reject
      patch :create
    end

    namespace :admin do
      resource :logins, only: %i[new create destroy]
      resources :log_entries, only: :index
      resource :master_data, only: %i[edit update]
      resources :participations, only: %i[index edit update] do
        get :inform
        get :join
        get :withdrawal
        get :withdrawal_check
        get :withdraw
      end
      resources :users
      root 'participations#index'
    end
    root 'participations#new'
  end
end
