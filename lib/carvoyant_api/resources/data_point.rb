module CarvoyantAPI
  class DataPoint

    attr_reader :id, :timestamp, :key, :value, :translated_value, :waypoint

    def initialize(attributes = {}, unit_format = :metric)
      @id = attributes[:id]
      @timestamp = attributes[:timestamp]
      @key = attributes[:key]
      @value = attributes[:value]
      @translated_value = attributes[:translatedValue]
      case @key
      when "GEN_WAYPOINT"
        latitude, longitude = @value.split(",")
        @waypoint = Waypoint.new(timestamp: @timestamp, latitude: latitude, longitude: longitude)
      when "GEN_ENGINE_COOLANT_TEMP"
        @translated_value = unit_format == :imperial ? Unit(@translated_value.gsub(" ", "")) : Unit(@translated_value.gsub(" ", "")).convert_to("degC")
        @value = @translated_value.scalar.to_f
        @translated_value = @translated_value.to_s("%.2f")
      when "GEN_SPEED"
        @translated_value = unit_format == :imperial ? Unit(@translated_value) : Unit(@translated_value).convert_to("kph")
        @value = @translated_value.scalar.to_f
        @translated_value = @translated_value.to_s("%.2f")
      end
    end
  end
end