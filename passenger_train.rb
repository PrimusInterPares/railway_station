# frozen_string_literal: true

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
