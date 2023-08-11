class Passenger_carriage
  include Manufacturer

  attr_reader :type

  TYPE = :passenger

  def initialize
    super
    @type = TYPE
  end
end
