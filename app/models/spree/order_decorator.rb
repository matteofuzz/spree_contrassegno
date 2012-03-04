Spree::Order.class_eval do
  
  StateMachine::Machine.ignore_method_conflicts = true
  Spree::Order.state_machines.clear
  
  # order state machine (see http://github.com/pluginaweek/state_machine/tree/master for details) 
  state_machine :initial => 'cart', :use_transactions => false do

    event :next do
      transition :from => 'cart',     :to => 'address'
      transition :from => 'address',  :to => 'delivery'
      transition :from => 'delivery', :to => 'payment', :if => :payment_required?
      transition :from => 'delivery', :to => 'complete'
      transition :from => 'confirm',  :to => 'complete'

      # note: some payment methods will not support a confirm step
      transition :from => 'payment',  :to => 'confirm',
                                      :if => Proc.new { |order| order.payment_method && order.payment_method.payment_profiles_supported? }

      transition :from => 'payment', :to => 'complete'
    end

    event :cancel do
      transition :to => 'canceled', :if => :allow_cancel?
    end
    event :return do
      transition :to => 'returned', :from => 'awaiting_return'
    end
    event :resume do
      transition :to => 'resumed', :from => 'canceled', :if => :allow_resume?
    end
    event :authorize_return do
      transition :to => 'awaiting_return'
    end

    before_transition :to => 'complete' do |order|
      begin
        order.process_payments!  
      rescue Spree::GatewayError
        if Spree::Config[:allow_checkout_on_gateway_error]
          true
        else
          false
        end
      end   
      ### CONTRASSEGNO customization  
      order.create_contrassegno!
      ###
    end

    before_transition :to => ['delivery'] do |order|
      order.shipments.each { |s| s.destroy unless s.shipping_method.available_to_order?(order) }
    end

    after_transition :to => 'complete', :do => :finalize!
    after_transition :to => 'delivery', :do => :create_tax_charge!
    after_transition :to => 'payment',  :do => :create_shipment!
    after_transition :to => 'resumed',  :do => :after_resume
    after_transition :to => 'canceled', :do => :after_cancel

  end

  # Creates a contrassegno adjustment
  def create_contrassegno! 
    if self.payment_method.type == "Spree::PaymentMethod::Contrassegno"
      spese_contrassegno = self.payment_method.compute(self)
      self.adjustments.create(:amount => spese_contrassegno, :source => self, :label => "Contrassegno", :mandatory => true) 
      # with contrassegno shipment borns ready
      self.shipment.ready
      update_shipment_state   
      update_totals
    end
  end

end