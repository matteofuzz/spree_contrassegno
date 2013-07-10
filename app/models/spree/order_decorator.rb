module Spree
  Order.class_eval do
  
    def process_payments_with_contrassegno!
      process_payments_without_contrassegno!
      create_contrassegno!
    end

    alias_method_chain :process_payments!, :contrassegno

  protected
    # Creates a contrassegno adjustment
    def create_contrassegno!
      if payments.first.payment_method.type == "Spree::PaymentMethod::Contrassegno"
        spese_contrassegno = payments.first.payment_method.compute(self)
        adjustments.create({:amount => spese_contrassegno, :source => self, :label => "Contrassegno", :mandatory => true}, :without_protection => true) 
        # update_totals
        update!
        # correct amount of contrassegno payment
        payments.first.update_attribute :amount, self.total
        # with contrassegno shipment borns ready
        shipment.update!(self)
        # aggiorna shipment_state
        update!
      end
    end

  end
end
