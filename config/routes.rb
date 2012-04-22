Spree::Core::Engine.routes.draw do
  # Add your extension routes here
  namespace :gateway do
    match '/seb/:gateway_id/:order_id' => 'seb#show', :as => :seb
    match '/swedbank/:gateway_id/:order_id' => 'swedbank#show', :as => :swedbank
    match '/seb/success' => 'seb#success', :as => :seb_success
    match '/seb/failure'   => 'seb#failure',   :as => :seb_failure
  end
  # 
  # resources :orders do
  #   resource :checkout, :controller => 'checkout' do
  #     member do
  #       get :paypal_checkout
  #       get :paypal_payment
  #       get :paypal_confirm
  #       post :paypal_finish
  #     end
  #   end
  # end
  # 
  # match '/ipizza_notify' => 'paypal_express_callbacks#notify', :via => [:get, :post]

end