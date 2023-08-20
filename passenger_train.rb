# frozen_string_literal: true

require_relative 'train'

class PassengerTrain < Train
  include InstanceCounter

  TYPE = :passenger

  def initialize(number)
    super
    @type = TYPE
  end

  def attach_carriage(carriage)
    super if carriage.type == type
  end
end
