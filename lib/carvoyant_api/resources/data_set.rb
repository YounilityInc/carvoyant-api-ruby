module CarvoyantAPI
  class DataSet
    attr_reader :id, :timestamp, :ignition_status, :data_points

    def initialize(attributes={}, unit_format = :metric)
      @timestamp = Time.parse(attributes[:timestamp])
      @ignition_status = attributes[:ignitionStatus]
      @data_points = attributes[:datum].map { |data_point| [data_point.key, DataPoint.new(data_point.attributes, unit_format)] }.to_h
    end
  end
end