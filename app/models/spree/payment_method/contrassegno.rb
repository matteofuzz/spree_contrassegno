module Spree
  class PaymentMethod::Contrassegno < PaymentMethod
  	preference :percentuale, :decimal, :default => 3.0
  	preference :minimo, :decimal, :default => 5.63
  
    def actions
      %w{capture void}
    end
  
    # Indicates whether its possible to capture the payment
    def can_capture?(payment)
      ['checkout', 'pending'].include?(payment.state)
    end
  
    # Indicates whether its possible to void the payment.
    def can_void?(payment)
      payment.state != 'void'
    end
  
    def capture(payment)
      payment.update_attribute(:state, 'pending') if payment.state == 'checkout'
      payment.complete  
      true
    end
  
    def void(payment)
      payment.update_attribute(:state, 'pending') if payment.state == 'checkout'
      payment.void
      true
    end
  
    def compute(order)
      perc = preferred_percentuale.to_f
      min = preferred_minimo.to_f
      amount = order.item_total
      [min, amount*perc/100].max * ((100 + Spree::Contrassegno::Config[:iva].to_f) / 100) 
    end
    
    def source_required?
      false
    end
    
  end
end