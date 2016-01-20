class ShipmentsController < ApplicationController

  def rates
    destination = get_location(params[:state], params[:city], params[:zip])
    origin = get_location(params[:state], params[:city], params[:zip])
    packages = get_packages(params[:packages])

    shipment_options = usps_rate(destination, origin, packages) + ups_rate(destination, origin, packages)

    if !shipment_options.empty?
      render json: shipment_options.as_json(except: [:created_at, :updated_at]), status: :ok
    else
      render json: [], status: 204
    end
  end

  def audit_logs
  end

  def verify_ups
    ActiveShipping::UPS.new(login: ENV["UPS_LOGIN"], password: ENV["UPS_PASSWORD"], key: ENV["UPS_KEY"])
  end

  def verify_usps
    ActiveShipping::USPS.new(login: ENV["UPS_LOGIN"])
  end

  def usps_rate(origin, destination, packages)
    response = verify_usps.find_rates(origin, destination, packages)

    usps_rates = response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price, rate.delivery_date]}

    return usps_rates
  end

  def ups_rate(origin, destination, packages)
    response = verify_ups.find_rates(origin, destination, packages)

    ups_rates = response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price, rate.delivery_date]}

    return ups_rates
  end

  def get_packages(request)
    packages = Array.new

    request.each do |package|
      packages << ActiveShipping::Package.new(package[:weight], [package[:height], package[:length], package[:width]], units: :imperial)
    end

    return packages
  end

  def get_location(state, city, zip)
    ActiveShipping::Location.new(:country => 'US', :state => state, :city => city, :zip => zip)
  end
end
