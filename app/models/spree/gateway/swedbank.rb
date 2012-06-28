module Spree
  class Gateway::Swedbank < Gateway::IpizzaGateway
    def payment_response(params)
      Ipizza::Provider::Swedbank.new.payment_response(params)
    end

    def method_type
      "swedbank"
    end
  end
end
