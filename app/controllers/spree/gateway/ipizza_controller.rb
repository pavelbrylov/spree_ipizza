module Spree
    class Gateway::IpizzaController < Spree::BaseController
      skip_before_filter :verify_authenticity_token, :only => [:success, :failure]

      def show
        @order = Order.find_by_number(params[:order_id])
        @gateway = @order.payment_method
        if @order.blank? || @gateway.blank?
          flash[:error] = I18n.t("Invalid arguments")
          redirect_to :back
        end
        @order.payments.destroy_all
        payment = @order.payments.create!(:amount => 0,  :payment_method_id => @gateway.id)
        @order_string = @order.line_items.collect{|item| item.variant.product.name }.join(", ")

        @bankpayment = ::Ipizza::Payment.new(
          :stamp => @order.number.to_s, :amount => @order.total, :refnum => @order.id, :message => @order_string, :currency => 'EUR'
        )

        render :action => :show
      end

      def success
        @order =  Order.find_by_number(params[:VK_STAMP])
        raise Spree::Core::GatewayError, "Order not found" unless @order
        @payment = @order.payments.first
        @payment.started_processing!
        payment_response = get_payment_response(params)
        raise Spree::Core::GatewayError, "Payment error, please contact website administrator" unless params[:VK_REF].to_i == Ipizza::Util.sign_731(@order.id.to_i).to_i

        logger.info "Payment response: #{payment_response.inspect}"
        raise Spree::Core::GatewayError, "Payment verification error, please contact website administrator" unless payment_response.valid?

        @payment.amount = params[:VK_AMOUNT].to_f
        @payment.save
        @payment.complete! unless @payment.state == "completed"
        @order.save!
        @order.finalize!

        session[:order_id] = nil
        flash[:notice] = I18n.t(:order_processed_successfully)
        flash[:commerce_tracking] = "nothing special"
        redirect_to order_path(@order)
      end

      def failure
        @order = Order.find_by_number(params[:VK_STAMP].to_i)
        flash.now[:error] = t("payment_fail")
        redirect_to @order.blank? ? root_url : checkout_state_path("payment")
          return
      end

      private
  
      def get_payment_response(params)
        raise Spree::Core::GatewayError, "Bank not specified!"
      end
    end
end