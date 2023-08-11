class CargoCarriage
  include Manufacturer

  attr_reader :type

  TYPE = :cargo

  def initialize
    super
    @type = TYPE
  end
end
