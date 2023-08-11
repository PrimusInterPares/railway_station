# Класс Train (Поезд):
# Имеет номер (произвольная строка) и тип (грузовой, пассажирский) и количество вагонов, эти данные указываются при создании экземпляра класса
# Может набирать скорость
# Может возвращать текущую скорость
# Может тормозить (сбрасывать скорость до нуля)
# Может возвращать количество вагонов
# Может прицеплять/отцеплять вагоны (по одному вагону за операцию, метод просто увеличивает или уменьшает количество вагонов).
# Прицепка/отцепка вагонов может осуществляться только если поезд не движется.
# Может принимать маршрут следования (объект класса Route).
# При назначении маршрута поезду, поезд автоматически помещается на первую станцию в маршруте.
# Может перемещаться между станциями, указанными в маршруте. Перемещение возможно вперед и назад, но только на 1 станцию за раз.
# Возвращать предыдущую станцию, текущую, следующую, на основе маршрута
# Добавить к поезду атрибут Номер (произвольная строка), если его еще нет, который указыватеся при его создании
# В классе Train создать метод класса find, который принимает номер поезда (указанный при его создании)
# и возвращает объект поезда по номеру или nil, если поезд с таким номером не найден.

require_relative 'instance_counter'
require_relative 'manufacturer'

class Train
  include Manufacturer
  include InstanceCounter
  attr_reader :number, :route, :current_station
  attr_accessor :type

  @@trains = []
  @@instances = 0

  def self.find(number)
    @@trains.find { |train| train.number == number }
  end

  NUMBER_FORMAT = /^[a-zа-яё0-9]{2}-?[a-zа-яё0-9]{2}$/i
  START_SPEED = 0

  def initialize(number)
    @number = number.to_s
    valid?
    @carriages = []
    @speed = START_SPEED
    @current_station = nil
    @@instances += 1
    register_instance
    @@trains.push(self)
  end

  def attach_carriage(carriage)
    @carriages.push(carriage) if type == carriage.type && speed.zero?
  end

  MIN_CARRIAGE_NUMBER = 0

  def uncouple_carriage(carriage)
    @carriages.delete(carriage) if speed.zero? && number_of_carriages != MIN_CARRIAGE_NUMBER && carriages.empty?
  end

  def route=(route)
    @route = route
    @current_station = route.first
  end

  def move_to_next_station
    @current_station = route.next_station(current_station) if !current_station.nil? && !route.last?(current_station)
  end

  def move_to_previous_station
    @current_station = route.previous_station(current_station) if !current_station.nil? && !route.first?(current_station)
  end

  def valid?
    validate!
    true
  rescue RuntimeError
    false
  end

  protected

  attr_accessor :speed, :number_of_carriages, :carriages
  attr_writer :current_station

  def validate!
    if number !~ NUMBER_FORMAT
      puts 'Формат номера задан неверно!'
      puts 'Допустимый формат: XX-XX или XXXX, где Х любая буква или цифра.'
      raise RuntimeError
    end
    if number.length < 4
      puts 'Номер поезда должен содержать не менее 4 символов.'
      raise RuntimeError
    end
  end

  private

  def accelerate
    speed.succ
  end

  def brake
    speed.pred
    self.speed = 0 if speed.negative?
  end

  def next_station
    route.next_station(current_station) unless route.last?
  end

  def previous_station
    route.previous_station(current_station) unless route.first?
  end
end
