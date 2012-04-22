module Spree
  class Gateway::IpizzaGateway < Gateway
    def provider_class
      self.class
    end

    def test?
      options[:test_mode] == true
    end
  end
end
