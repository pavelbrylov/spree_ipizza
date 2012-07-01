module Spree
  class Gateway::IpizzaGateway < Gateway
    def provider_class
      self.class
    end

    #Overring preferences set in Gateway model
    def preferences
      {}
    end

    def test?
      options[:test_mode] == true
    end
  end
end
