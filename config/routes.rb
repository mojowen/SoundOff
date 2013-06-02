SoundOff::Application.routes.draw do

  devise_for :users, :path => '', :path_names => {:sign_in => 'login', :sign_out => 'logout'}

  match '/form' => 'frame#form'
  match '/widget' => 'frame#widget'
  match '/widget_create' => 'frame#demo', :as => 'widget_create'

  match '/home' => 'home#home', :as => 'home'

  match '/all_reps' => 'rep#index', :as => 'all_reps'
  match '/find_reps' => 'rep#search', :as => 'all_reps'
  

  match '/:short_url' => 'home#home', :as => 'short'
  match '/rep/:twitter_screen_name' => 'home#home', :as => 'rep'
  
end
