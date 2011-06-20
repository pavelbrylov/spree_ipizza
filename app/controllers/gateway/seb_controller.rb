class Gateway::SebController < Gateway::IpizzaController
  private
  
  def get_payment_response(params)
    Ipizza::Provider::Seb.new.payment_response(params)
  end
end