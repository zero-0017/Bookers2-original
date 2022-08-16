Rails.application.routes.draw do
  get 'chats/show'
  devise_for :users

  root to: "homes#top"
  get "home/about"=>"homes#about"
  get "search" => "searches#search"

  resources :books, only: [:index,:show,:edit,:create,:destroy,:update] do
  resource :favorites, only: [:create, :destroy]
  resources :book_comments, only: [:create, :destroy]
end

  resources :users, only: [:index,:show,:edit,:update] do
      resource :relationships, only: [:create, :destroy]
    get :following, on: :member
    get :follower, on: :member
end
  get 'chats/:id', to: 'chats#show', as: 'chat'
  resources :chats, only: [:create]

end