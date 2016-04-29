Rails.application.routes.draw do
  root 'shifts#index'
  get '/shifts' => 'shifts#shifts'
end
