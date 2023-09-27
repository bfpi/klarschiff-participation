Rails.application.routes.draw do
  scope Rails.application.config.relative_url_root || '/' do
    resources :participation, only: %i[new create]
  end

  root 'participation#new'
end
