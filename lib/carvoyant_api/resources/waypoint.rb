class CarvoyantAPI::Waypoint
  attr_reader :timestamp, :latitude, :longitude

  def initialize(attributes = {})
    @timestamp = Time.parse(attributes[:timestamp])
    @latitude = attributes[:latitude].to_f
    @longitude = attributes[:longitude].to_f
  end

  def to_s
    "#{@latitude}, #{@longitude}"
  end
end