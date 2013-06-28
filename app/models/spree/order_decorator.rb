module Spree
    Order.class_eval do
  
    def process_payments!
      begin
        pending_payments.each do |payment|
          break if payment_total >= total

          payment.process!

          if payment.completed?
            self.payment_total += payment.amount
          end
        end
        ### CONTRASSEGNO customization  
        create_contrassegno!
        ###
      rescue Core::GatewayError
        !!Spree::Config[:allow_checkout_on_gateway_error]
      end
    end

    # Creates a contrassegno adjustment
    def create_contrassegno! 
      if payment_method.type == "Spree::PaymentMethod::Contrassegno"
        spese_contrassegno = payment_method.compute(self)
        adjustments.create({:amount => spese_contrassegno, :source => self, :label => "Contrassegno", :mandatory => true}, :without_protection => true) 
        # update_totals
        update!
        # correct amount of contrassegno payment
        payment.update_attribute :amount, self.total
        # with contrassegno shipment borns ready
        shipment.update!(self)
        # aggiorna shipment_state
        update!
      end
    end

  end
end