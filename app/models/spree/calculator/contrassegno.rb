module Spree
  class Calculator::Contrassegno < Calculator
    preference :percentuale, :decimal, :default => 3.0
  	preference :minimo, :decimal, :default => 5.63

    def self.description
      I18n.t("contrassegno")
    end

    def self.available?(object)
      true
    end

    def self.register
      super
      #ShippingMethod.register_calculator(self)
    end

    def compute(object)
      ca = self.calculable 
      ca ||= self
      perc = ca.preferred_percentuale
      min = ca.preferred_minimo
      amount = object.item_total
      [min, amount*perc/100].max * ((100 + Spree::Config[:iva].to_f) / 100) 
    end
  end
end