# frozen_string_literal: true

require_relative 'train'

class CargoTrain < Train
  include InstanceCounter

  TYPE = :cargo

  def initialize(number)
    super
    @type = TYPE
  end

  def attach_carriage(carriage)
    super if carriage.type == type
  end
end
