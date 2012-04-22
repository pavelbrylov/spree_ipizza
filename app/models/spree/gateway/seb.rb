module Spree
  class Gateway::Seb < Gateway::IpizzaGateway

    def method_type
      "seb"
    end
  end
end
