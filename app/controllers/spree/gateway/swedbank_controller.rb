module Spree
    class Gateway::SwedbankController < Gateway::IpizzaController
      private
  
      def get_payment_response(params)
        Ipizza::Provider::Swedbank.new.payment_response(params)
      end
    end
end