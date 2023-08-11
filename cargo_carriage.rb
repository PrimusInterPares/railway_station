class Cargo_carriage
  include Manufacturer

  attr_reader :type

  TYPE = :cargo

  def initialize
    super
    @type = TYPE
  end
end
