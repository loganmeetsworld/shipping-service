class Ups
  attr_accessor :ups_audit
  
  def initialize
    @ups_audit = ActiveShipping::UPS.new(login: ENV["UPS_LOGIN"], password: ENV["UPS_PASSWORD"], key: ENV["UPS_KEY"])
  end

  def find_rates(shipment_params)
    origin = ActiveShipping::Location.new(:country => 'US', :state => shipment_params[state], :city => shipment_params[city], :zip => shipment_params[zip])
    destination = ActiveShipping::Location.new(:country => 'US', :state => shipment_params[state], :city => shipment_params[city], :zip => shipment_params[zip])

    packages = Array.new

    request.each do |package|
      packages << ActiveShipping::Package.new(package[:weight], [package[:height], package[:length], package[:width]], units: :imperial, :currency => "USD")
    end

    response = usps.find_rates(origin, destination, packages)
    rates = response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price]}

    return rates
  end
end