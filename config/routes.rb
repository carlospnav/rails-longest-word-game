Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'game#index'
  get 'game', to: 'game#index'

  get 'score', to: 'game#score'
  post 'score', to: 'game#score'
end
