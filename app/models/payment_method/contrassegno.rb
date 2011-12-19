class PaymentMethod::Contrassegno < PaymentMethod
	preference :percentuale, :decimal, :default => 3.0
	preference :minimo, :decimal, :default => 5.63
	
	calculated_adjustments
	
  after_create :initialize_calculator
  
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
  
  
  private
  
  def initialize_calculator
	  self.calculator = Calculator::Contrassegno.new
  end
end
