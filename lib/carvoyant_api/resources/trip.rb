module CarvoyantAPI
  class TripJsonFormatter
    include ActiveResource::Formats::JsonFormat

    def decode(json)
      ActiveSupport::JSON.decode(json)["trip"]
    end
  end

  class Trip < Base

    self.prefix = '/v1/api/vehicle/:vehicle_id/'
    self.format = TripJsonFormatter.new
    self.primary_key = :id

    schema do
      integer 'id'
      string 'startTime', 'endTime', 'startWaypoint', 'endWaypoint', 'data'
    end

    attr_reader :start_waypoint, :end_waypoint, :start_time, :end_time, :in_progress, :data_sets


    class << self
      def unit_format(unit_format = :metric)
        Thread.current["active.resource.unit_formats.#{self.object_id}"] = unit_format
        self
      end

      def current_unit_format
        Thread.current["active.resource.unit_formats.#{self.object_id}"] || :metric
      end
    end


    def initialize(attributes = {}, persisted = false)
      super
      @start_waypoint = Waypoint.new(startWaypoint.attributes) if startWaypoint
      @end_waypoint = Waypoint.new(endWaypoint.attributes) if endWaypoint
      @start_time = Time.parse(startTime) if startTime
      @end_time = endTime ? Time.parse(endTime) : Time.current
      @in_progress = endTime.nil?
      @data_sets = data.map { |data_set| DataSet.new(data_set.attributes, self.class.current_unit_format) } if data
      @mileage = Unit("#{self.attributes[:mileage] || 0} miles")
      @mileage = @mileage.convert_to("km") if metric?
    end

    def locations
      @data_sets.each.map { |data_set| data_set.data_points["GEN_WAYPOINT"].try(:waypoint)}.compact
    end

    def average_speed
       speed = @mileage.scalar / ((@end_time - @start_time) / 1.hours)
       speed = imperial? ? Unit("#{speed} mph") : Unit("#{speed} kph")
       speed.to_s("%0.2f")
    end

    def max_speed
      speed = @data_sets.map { |data_set| data_set.data_points["GEN_SPEED"].try(:value) }.compact.max
      speed = imperial? ? Unit("#{speed} mph") : Unit("#{speed} kph")
      speed.to_s("%0.2f")
    end

    def mileage
      @mileage
    end
    def imperial?
      self.class.current_unit_format == :imperial
    end

    def metric?
      !imperial?
    end
  end
end