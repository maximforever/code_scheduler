Rails.application.routes.draw do
  root 'shifts#shifts'
  get '/index' => 'shifts#index'
end
