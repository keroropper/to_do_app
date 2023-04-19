Rails.application.routes.draw do

  root "static_pages#home"
  devise_for :users, skip: :all
  devise_scope :user do
    get '/login', to: 'devise/sessions#new'
    post '/login', to: 'devise/sessions#create'
    delete '/logout', to: 'devise/sessions#destroy'
    get '/signup', to: 'devise/registrations#new'
    post '/signup', to: 'devise/registrations#create'
    get 'signup/cancel', to: 'devise/registrations#cancel'
    get '/user', to: 'devise/registrations#edit'
    patch '/user', to: 'devise/registrations#update'
    put '/user', to: 'devise/registrations#update'
    delete '/user', to: 'devise/registrations#destroy'
    get '/password', to: 'devise/passwords#new'
    post '/password', to: 'devise/passwords#create'
    get 'password/edit', to: 'devise/passwords#edit'
    patch '/password', to: 'devise/passwords#update'
    put '/password', to: 'devise/passwords#update'
  end
end
