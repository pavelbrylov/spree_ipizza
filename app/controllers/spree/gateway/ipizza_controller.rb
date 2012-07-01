module Spree
    class Gateway::IpizzaController < Spree::BaseController
      before_filter :load_order#, :except => [:show, :search]

      skip_before_filter :verify_authenticity_token, :only => [:success, :failure]

      def show
        if @order.blank? or @gateway.blank?
          flash[:error] = I18n.t("unable_to_find_order")
          redirect_to (request.env["HTTP_REFERER"]) ? :back : root_url
          return
        end

        # Destroy all payments made so far
        @order.payments.destroy_all
        @order.payments.create!(:amount => 0, :payment_method_id => @gateway.id)

        # Generate product names for bank page
        order_string = @order.line_items.collect{|item| item.variant.product.name }.join(", ")

        @bankpayment = ::Ipizza::Payment.new(
          :stamp => @order.number.to_s, :amount => @order.total, :refnum => @order.id, :message => order_string, :currency => 'EUR'
        )

        render :action => :show
      end

      def success
        raise Spree::Core::GatewayError, "Order not found" unless @order
        payment = @order.payments.first
        payment.started_processing!

        # Check 7-3-1 algorithm
        if params[:VK_REF].to_i != Ipizza::Util.sign_731(@order.id.to_i).to_i
          raise Spree::Core::GatewayError, "Payment error, please contact website administrator"
        end

        # Validate response
        if !@gateway.payment_response(params).valid?
          raise Spree::Core::GatewayError, "Payment verification error, please contact website administrator" 
        end

        payment.amount = params[:VK_AMOUNT].to_f
        payment.save
        payment.complete! unless payment.state == "completed"
        @order.save!
        @order.finalize!

        session[:order_id] = nil
        flash[:notice] = I18n.t(:order_processed_successfully)
        flash[:commerce_tracking] = "ipizza"
        redirect_to order_path(@order)
      end

      def failure
        flash.now[:error] = t("payment_fail")
        redirect_to @order.blank? ? root_url : checkout_state_path("payment")
      end

      private

      def load_order
        @order = Order.find_by_number(params[:order_id]) if params[:order_id]
        @order = Order.find_by_number(params[:VK_STAMP]) if params[:VK_STAMP]
        @gateway = @order.payment_method unless @order.nil?
      end
    end
end
