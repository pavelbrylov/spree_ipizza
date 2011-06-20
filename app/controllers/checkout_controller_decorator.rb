CheckoutController.class_eval do
  before_filter :redirect_to_ipizza_form_if_needed, :only => :update

  private

  # Redirect to iPizza
  #
  def redirect_to_ipizza_form_if_needed
    return unless params[:state] == "payment"
    payment_method = PaymentMethod.find(params[:order][:payments_attributes].first[:payment_method_id])
    if payment_method.kind_of? Gateway::Seb
      if !request.ssl? && Rails.env =~ /production/
        redirect_to gateway_seb_path(:gateway_id => payment_method.id, :order_id => @order.id,
                                          :protocol => "https", :host => Rails.configuration.main_domain)
      else
        redirect_to gateway_seb_path(:gateway_id => payment_method.id, :order_id => @order.id)
      end
    elsif payment_method.kind_of? Gateway::Swedbank
      if !request.ssl? && Rails.env =~ /production/
        redirect_to gateway_swedbank_path(:gateway_id => payment_method.id, :order_id => @order.id,
                                          :protocol => "https", :host => Rails.configuration.main_domain)
      else
        redirect_to gateway_swedbank_path(:gateway_id => payment_method.id, :order_id => @order.id)
      end
    end

  end

end
