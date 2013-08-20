SoundOff::Application.routes.draw do

  devise_for :users, :path => '', :path_names => {:sign_in => 'login', :sign_out => 'logout'}

  resources :partners
  resources :campaigns

  match '/sign_up' => 'partners#new', :as => 'registration'

  match '/form' => 'frame#form', :via => :get
  match '/form' => 'frame#save', :via => :post
  match '/widget' => 'frame#widget'

  match '/' => 'home#home', :as => 'home'
  match '/home' => 'home#home', :as => 'action', :defaults => { :short_url => 'home'}
  match '/all_names' => 'home#all_names', :as => 'all'
  match '/all_tweets' => 'home#all_tweets', :as => 'tweets'
  match '/all_responses' => 'home#all_responses', :as => 'responses'
  match '/statuses' => 'home#statuses', :as => 'statuses'
  match '/sitemap' => 'home#sitemap'

  match '/all_reps' => 'rep#index', :as => 'all_reps'
  match '/find_reps' => 'rep#search', :as => 'find_reps'

  match '/help' => 'pages#contact', :as => 'help'
  match '/press' => 'pages#press', :as => 'press'
  match '/about' => 'pages#about', :as => 'about'
  match '/contact' => 'pages#contact', :as => 'contact'
  match '/tos' => 'pages#tos', :as => 'tos'
  match '/privacy' => 'pages#privacy', :as => 'privacy'

  match '/:short_url' => 'home#home', :as => 'short'
  match '/rep/:twitter_screen_name' => 'home#home', :as => 'rep'
  match '/direct/:short_url' => 'frame#direct', :as => 'direct'


end
