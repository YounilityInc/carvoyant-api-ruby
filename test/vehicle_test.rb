require 'test_helper'
class VehicleTest < Minitest::Test

  def test_get_vehicle
    fake "/v1/api/vehicle/2230", :method => :get, :body => load_fixture('vehicle')
    vehicle = CarvoyantAPI::Vehicle.find(2230)
    assert_equal 2230, vehicle.vehicleId
  end

  def test_post_vehicle
    fake "/v1/api/vehicle/", :method => :post, :body => load_fixture('vehicle')
    vehicle = CarvoyantAPI::Vehicle.create(deviceId: "C201401286", vin: "1FADP3F2XEL352103")
    assert_equal 2230, vehicle.id
    assert_equal "C201401286", vehicle.deviceId
  end

  def test_get_vehicles
    fake "/v1/api/vehicle/", :method => :get, :body => load_fixture('vehicles')
    vehicles = CarvoyantAPI::Vehicle.all
    assert_equal 6, vehicles.length
  end

  def test_update_vehicle
    skip
    fake "/v1/api/vehicle/2230", method: :get, body: load_fixture('vehicle')
    fake "/v1/api/vehicle/2230", method: :post, body: load_fixture('vehicle')

    # add lines to test update here

    assert_equal vehicle.vin, '1FADP3F2XEL352103'
  end

  def test_not_running
    fake "/v1/api/vehicle/2230", method: :get, body: load_fixture('vehicle')
    vehicle = CarvoyantAPI::Vehicle.find(2230)
    assert_equal false, vehicle.running? 
  end

  def test_vehicle_without_label
    fake "/v1/api/vehicle/2230", method: :get, body: load_fixture('vehicle_without_label')
    vehicle = CarvoyantAPI::Vehicle.find(2230)
    assert_equal false, vehicle.label.nil?
  end

  def test_error_handling
    fake "/v1/api/vehicle/", :method => :post, body: load_fixture('deviceId_error'), status: ["500", "Internal Server Error"]
    vehicle = CarvoyantAPI::Vehicle.create(deviceId: "C201401288")
    assert_includes vehicle.errors["deviceId"], "The deviceId is in use by another vehicle."
  end
end

