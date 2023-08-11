# Класс Station (Станция):
# Имеет название, которое указывается при ее создании
# Может принимать поезда (по одному за раз)
# Может возвращать список всех поездов на станции, находящиеся в текущий момент
# Может возвращать список поездов на станции по типу (см. ниже): кол-во грузовых, пассажирских
# Может отправлять поезда (по одному за раз, при этом, поезд удаляется из списка поездов, находящихся на станции).
# В классе Station (жд станция) создать метод класса all, который возвращает все станции (объекты), созданные на данный момент

require_relative 'instance_counter'

class Station
  include InstanceCounter

  attr_accessor :name

  @@stations = []

  MIN_NAME_LENGTH = 3
  MAX_NAME_LENGTH = 15

  def self.all
    stations
  end

  def initialize(name)
    @name = name.to_s
    valid?
    @train_list = []
    register_instance
    @@stations.push(self)
  end

  def train_list=(train)
    train_list.push(train)
  end

  def train_list_by_type
    trains.select { |train| train.type == type }
    # train_list.each_with_object(Hash.new(0)) { |train, h| h[train.type] += 1 }
  end

  def send_train(train)
    train_list.delete(train) if trains.include?(train)
  end

  def valid?
    validate!
    true
  rescue RuntimeError
    false
  end

  protected

  def validate!
    if name.length < MIN_NAME_LENGTH
      puts "Имя станции не должно быть меньше #{MIN_NAME_LENGTH} символов."
      raise RuntimeError
    end
    if name.length > MAX_NAME_LENGTH
      puts "Имя станции не должно превышать #{MAX_NAME_LENGTH} символов."
      raise RuntimeError
    end
  end

  attr_reader :train_list
end
