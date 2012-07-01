Spree::Core::Engine.routes.draw do
  namespace :gateway do
    match '/banklink/success'   => 'ipizza#success', :as => :ipizza_success, :method => :post
    match '/banklink/failure'   => 'ipizza#failure', :as => :ipizza_failure, :method => :post
    match '/banklink/:order_id' => 'ipizza#show',    :as => :ipizza, :constraints => 'R(\d{9})$'
  end
end
