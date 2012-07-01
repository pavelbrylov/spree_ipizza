require 'spec_helper'

describe Spree::Gateway::IpizzaController do

it "should redirect back if order not found and referer exists" do
  request.env["HTTP_REFERER"] = "previous_url"
  spree_get :show, :order_id => ''
  response.should redirect_to("previous_url")
end

it "should redirect to root_path if order not found and there is no referer" do
  spree_get :show, :order_id => 'i578037'
  response.should redirect_to spree.root_path
end

end
