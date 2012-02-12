# Override per il contrassegno    
Spree::Shipment.class_eval do
  # Determines the appropriate +state+ according to the following logic:
  #
  # pending    unless +order.payment_state+ is +paid+
  # shipped    if already shipped (ie. does not change the state)
  # ready      all other cases
  def determine_state(order)
    return "pending" if self.inventory_units.any? {|unit| unit.backordered?}
    return "shipped" if state == "shipped"  
    return "ready" if order.payment_method.type == "Spree::PaymentMethod::Contrassegno"
    order.payment_state == "balance_due" ? "pending" : "ready"
  end
end