Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      resources :questions, only: [:show] do
        put 'answer/:answer_id', to: 'questions#update'
      end
      namespace :admins do
        resources :question, only: [:create, :update], controller: 'admins/questions'
        resources :users, only: [:index], controller: 'admins/users'
      end
    end
  end
end
