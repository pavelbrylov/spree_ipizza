module Spree
  CheckoutController.class_eval do
    before_filter :redirect_to_ipizza_form_if_needed, :only => [:update]

    private

    # Redirect to iPizza
    #
    def redirect_to_ipizza_form_if_needed
      return unless (params[:state] == "payment")
      payment_method = Spree::PaymentMethod.find(params[:order][:payments_attributes].first[:payment_method_id])

      if payment_method.kind_of? Spree::Gateway::Seb
        if !request.ssl? && Rails.env =~ /production/
          redirect_to gateway_seb_path(:order_id => @order.number, :protocol => "https", :host => Rails.configuration.main_domain)
        else
          redirect_to gateway_seb_path(:order_id => @order.number)
        end
      elsif payment_method.kind_of? Spree::Gateway::Swedbank
        if !request.ssl? && Rails.env =~ /production/
          redirect_to gateway_swedbank_path(:order_id => @order.number, :protocol => "https", :host => Rails.configuration.main_domain)
        else
          redirect_to gateway_swedbank_path(:order_id => @order.number)
        end
      end

    end

  end
end