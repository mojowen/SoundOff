SoundOff::Application.routes.draw do

  devise_for :users, :path => '', :path_names => {:sign_in => 'login', :sign_out => 'logout'}

  resources :partners
  resources :campaigns

  match '/sign_up' => 'partners#new', :as => 'registration'

  match '/form' => 'frame#form'
  match '/widget' => 'frame#widget'
  match '/widget_create' => 'frame#demo', :as => 'widget_create'

  match '/home' => 'home#home', :as => 'home'

  match '/all_reps' => 'rep#index', :as => 'all_reps'
  match '/find_reps' => 'rep#search', :as => 'all_reps'

  match '/press' => 'pages#press', :as => 'press'
  match '/about' => 'pages#about', :as => 'about'
  match '/contact' => 'pages#contact', :as => 'contact'
  match '/tos' => 'pages#tos', :as => 'tos'

  match '/:short_url' => 'home#home', :as => 'short'
  match '/rep/:twitter_screen_name' => 'home#home', :as => 'rep'


end
