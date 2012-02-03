class Spree::ContrassegnoConfiguration < Spree::Preferences::Configuration
  preference :iva, :decimal, :default => 21.0
end