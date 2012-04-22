module Spree
  class Gateway::Swedbank < Gateway::IpizzaGateway

    def method_type
      "swedbank"
    end
  end
end
