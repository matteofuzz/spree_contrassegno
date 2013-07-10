# Override per il contrassegno    
Spree::Shipment.class_eval do

  # Determines the appropriate +state+ according to the following logic:
  #
  # Se Contrassegno
  #   shipped se shipped
  #   altrimenti ready
  # Comportamento standard
  #   pending    unless order is complete and +order.payment_state+ is +paid+
  #   shipped    if already shipped (ie. does not change the state)
  #   ready      all other cases

  def determine_state_with_payment_method_check(order)
    if order.payments.first and order.payments.first.is_a?(Spree::PaymentMethod::Contrassegno)
      return 'shipped' if state == 'shipped'
      return 'ready'
    else
      return determine_state_without_payment_method_check(order)
    end  
  end
  
  alias_method_chain :determine_state, :payment_method_check

end

