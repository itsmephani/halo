Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # Serve websocket cable requests in-process
  # mount ActionCable.server => '/cable'
  match '(errors)/:status', to: 'thin#render_error', constraints: {status: /\d{3}/}, via: :all
  
  namespace :api,  defaults: {format: :json} do
    
    resources :registrations, only: :create
    post 'registrations/send_password_reset', to: 'registrations#send_password_reset'
    put 'registrations/reset_password', to: 'registrations#reset_password'
   
    #login
    resources :sessions, only: [:create, :destroy]
    #provider login eg. facebook
    post 'login/:provider', to: 'registrations#auth_user_login'

    get 'users/me', to: 'users#me'
    put 'users', to: 'users#update'
    

  end

end
