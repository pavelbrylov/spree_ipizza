module Spree
  class Gateway::Seb < Gateway::IpizzaGateway
    def payment_response(params)
      Ipizza::Provider::Seb.new.payment_response(params)
    end

    def method_type
      "seb"
    end
  end
end
