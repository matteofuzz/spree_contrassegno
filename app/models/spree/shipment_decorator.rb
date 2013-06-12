# Override per il contrassegno    
Spree::Shipment.class_eval do
  # Determines the appropriate +state+ according to the following logic:
  #
  # ready if contrassegno
  # pending    unless order is complete and +order.payment_state+ is +paid+
  # shipped    if already shipped (ie. does not change the state)
  # ready      all other cases
  def determine_state(order)
    return "ready" if order.payment_method.is_a? Spree::PaymentMethod::Contrassegno
    return 'pending' unless order.can_ship?
    return 'pending' if inventory_units.any? &:backordered?
    return 'shipped' if state == 'shipped'
    order.paid? ? 'ready' : 'pending'
  end
end