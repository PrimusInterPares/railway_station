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

  def uncouple_carriage(carriage)
    super if carriage.type == type
  end
end
