Rails.application.routes.draw do
  root to: 'posts#index'
  devise_for :users
  resources :posts
  resources :users, only: [:show, :edit, :update]
  resources :parts, only: [:index]
  resources :post_tags, only: [:index] do #投稿のタグ絞り込み画面へのルーティング
    get 'posts', to: 'posts#narrowing'
  end
  resources :part_tags, only: [:index] do #パーツのタグ絞り込み画面へのルーティング
    get 'parts', to: 'parts#narrowing'
  end

  get '/search' => 'searchs#search'

end
