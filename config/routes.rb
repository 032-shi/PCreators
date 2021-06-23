Rails.application.routes.draw do
  root to: 'posts#index'
  devise_for :users
  resources :posts do
    resources :post_comments, only: [:create, :destroy]
    resource :post_favorites, only: [:create, :destroy]
  end

  resources :users, only: [:show, :edit, :update]
  resources :parts, only: [:index, :show] do
   resources :draft_configurations, only: [:create]
  end
  resources :draft_configurations, only: [:index, :update, :destroy]
  resources :pc_configurations

  resources :post_tags, only: [:index] do
    get 'posts', to: 'posts#narrowing' #投稿のタグ絞り込み画面へのルーティング
  end
  resources :part_tags, only: [:index] do
    get 'parts', to: 'parts#narrowing' #パーツのタグ絞り込み画面へのルーティング
  end

  get 'searchs' => 'searchs#search'

end
