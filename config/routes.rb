Rails.application.routes.draw do
  devise_for :users

  root to: "homes#top"
  get "home/about"=>"homes#about"
  get "search" => "searches#search"
  get "search_book" => "books#search_book"

  resources :books, only: [:index,:show,:edit,:create,:destroy,:update] do
  resource :favorites, only: [:create, :destroy]
  resources :book_comments, only: [:create, :destroy]
end

  resources :users, only: [:index,:show,:edit,:update] do
    resource :relationships, only: [:create, :destroy]
    get :following, on: :member
    get :follower, on: :member
    get "search", to: "users#search"
end
  resources :chats, only: [:show, :create]
  resources :groups do
    get 'join' => 'groups#join'
    resources :event_notices, only: [:new, :create]
    get "event_notices" => "event_notices#sent"
  end

  devise_scope :user do
    post 'users/guest_sign_in', to: 'users/sessions#guest_sign_in'
  end

end