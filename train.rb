# frozen_string_literal: true

# Класс Train (Поезд):
# Имеет номер (произвольная строка) и тип (грузовой, пассажирский) и количество вагонов,
#   эти данные указываются при создании экземпляра класса
# Может набирать скорость
# Может возвращать текущую скорость
# Может тормозить (сбрасывать скорость до нуля)
# Может возвращать количество вагонов
# Может прицеплять/отцеплять вагоны (по одному вагону за операцию, метод увеличивает или уменьшает количество вагонов).
# Прицепка/отцепка вагонов может осуществляться только если поезд не движется.
# Может принимать маршрут следования (объект класса Route).
# При назначении маршрута поезду, поезд автоматически помещается на первую станцию в маршруте.
# Может перемещаться между станциями, указанными в маршруте.
#   Перемещение возможно вперед и назад, но только на 1 станцию за раз.
# Возвращать предыдущую станцию, текущую, следующую, на основе маршрута

# Добавить к поезду атрибут Номер (произвольная строка), если его еще нет, который указыватеся при его создании
# В классе Train создать метод класса find, который принимает номер поезда (указанный при его создании)
# и возвращает объект поезда по номеру или nil, если поезд с таким номером не найден.

# написать метод, который принимает блок и проходит по всем вагонам поезда (вагоны должны быть во внутреннем массиве),
# передавая каждый объект вагона в блок.

require_relative 'instance_counter'
require_relative 'manufacturer'

class Train
  include Manufacturer
  include InstanceCounter
  attr_reader :number, :route, :current_station
  attr_accessor :type

  TYPE = :unknown
  MIN_CARRIAGE_NUMBER = 0
  NUMBER_FORMAT = /^[a-zа-яё0-9]{2}-?[a-zа-яё0-9]{2}$/i
  START_SPEED = 0

  @@all_trains = []


  
  def self.find(number)
    @@all_trains.find { |train| train.number == number }
  end

  def initialize(number)
    @number = number.to_s
    validate!
    @carriages = []
    @speed = START_SPEED
    @current_station = nil
    @type = TYPE
    register_instance
    @@all_trains.push(self)
  end

  def attach_carriage(carriage)
    @carriages.push(carriage) if type == carriage.type && speed.zero?
  end

  def uncouple_carriage
    @carriages.delete_at(-1) if speed.zero? && number_of_carriages != MIN_CARRIAGE_NUMBER && carriages.empty?
  end

  def route=(route)
    @route = route
    @current_station = route.first
  end

  # rubocop:disable Style/GuardClause
  def move_to_next_station
    if !current_station.nil? && !route.last?(current_station)
      current_station.send_train(self)
      @current_station = route.next_station(current_station)
      current_station.train_list = self
    end
  end

  def move_to_previous_station
    if !current_station.nil? && !route.first?(current_station)
      current_station.send_train(self)
      @current_station = route.previous_station(current_station)
      current_station.train_list = self
    end
  end
  # rubocop:enable Style/GuardClause

  def accelerate
    speed.succ
  end

  def brake
    speed.pred
    self.speed = 0 if speed.negative?
  end

  def each_carriage(&block)
    carriages.each { |carriage| block.call(carriage) } if block_given?
  end

  protected

  attr_accessor :speed, :number_of_carriages, :carriages
  attr_writer :current_station

  private

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
    @@all_trains.each do |train|
      if train.number == number
        puts 'Поезд с таким номером уже существует.'
        raise RuntimeError
      end
    end
  end

  def next_station
    route.next_station(current_station) unless route.last?
  end

  def previous_station
    route.previous_station(current_station) unless route.first?
  end
end
