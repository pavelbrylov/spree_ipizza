Rails.application.routes.draw do
  # Add your extension routes here
  namespace :gateway do
    match '/seb/:gateway_id/:order_id' => 'seb#show', :as => :seb
    match '/swedbank/:gateway_id/:order_id' => 'swedbank#show', :as => :swedbank
    match '/seb/success' => 'seb#success', :as => :seb_success
    match '/seb/failure'   => 'seb#failure',   :as => :seb_failure
  end
end
