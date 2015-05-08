module CarvoyantAPI
  class VehicleJsonFormatter
    include ActiveResource::Formats::JsonFormat

    def decode(json)
      ActiveSupport::JSON.decode(json)["vehicle"]
    end
  end

  class Vehicle < Base
    self.format = VehicleJsonFormatter.new
    self.primary_key = :vehicleId

    attr_reader :last_waypoint, :last_running_timestamp

    schema do
      integer "id", "deviceId"
      string "label", "name", "vin", "lastWaypoint", "year", "make", "model", "running", "lastRunningTimestamp"
      float "mileage"
    end

    def initialize(attributes = {}, persisted = false)
      super
      @last_waypoint = Waypoint.new(lastWaypoint.attributes) if self.attributes["lastWaypoint"]
      @last_running_timestamp = Time.parse(lastRunningTimestamp) if self.attributes["lastRunningTimestamp"]
      self.attributes["label"] ||= ""
    end

    def running?
      if @last_waypoint && @last_running_timestamp
        @last_waypoint.timestamp >= Time.now - 2.minutes && @last_running_timestamp >= Time.now - 2.minutes
      else
        running == "true"
      end
    end
  end
end