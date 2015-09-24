module CarvoyantAPI
  class VehicleJsonFormatter
    include ActiveResource::Formats::JsonFormat

    def decode(json)
      ActiveSupport::JSON.decode(json)['vehicle']
    end
  end

  class Vehicle < Base
    self.format = VehicleJsonFormatter.new
    self.primary_key = :vehicleId

    attr_reader :last_waypoint, :last_running_timestamp

    schema do
      integer 'id'
      string 'label', 'name', 'vin', 'lastWaypoint', 'year', 'make', 'model', 'running', 'deviceId', 'lastRunningTimestamp'
      float 'mileage'
    end

    def initialize(attributes = {}, persisted = false)
      super
      self.attributes['deviceId'] ||= ''
      self.attributes['label'] ||= ''
      @last_waypoint = Waypoint.new(lastWaypoint.attributes) if lastWaypoint
      @last_running_timestamp = Time.parse(lastRunningTimestamp) if lastRunningTimestamp
    end

    def running?
      running == 'true'
    end
  end
end