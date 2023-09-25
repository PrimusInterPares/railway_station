# frozen_string_literal: true

# Класс Station (Станция):
# Имеет название, которое указывается при ее создании
# Может принимать поезда (по одному за раз)
# Может возвращать список всех поездов на станции, находящиеся в текущий момент
# Может возвращать список поездов на станции по типу (см. ниже): кол-во грузовых, пассажирских
# Может отправлять поезда (по одному за раз, при этом, поезд удаляется из списка поездов, находящихся на станции).

# В классе Station (жд станция) создать метод класса all, который возвращает все станции (объекты),
# созданные на данный момент

# написать метод, который принимает блок и проходит по всем поездам на станции, передавая каждый поезд в блок.

require_relative 'instance_counter'
require_relative 'accessors'
require_relative 'validation'

class Station
  include InstanceCounter
  include Accessors
  include Validation

  attr_accessor :name

  @@all_stations = []

  MIN_NAME_LENGTH = 3
  MAX_NAME_LENGTH = 15

  def self.all
    @@all_stations
  end

  def initialize(name)
    @name = name.to_s
    self.class.clear
    self.class.validate name, 'presence'
    self.class.validate name, 'min_length', MIN_NAME_LENGTH
    self.class.validate name, 'max_length', MAX_NAME_LENGTH
    validate!
    @train_list = []
    register_instance
    @@all_stations.push(self)
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

  def each_train(&block)
    train_list.each { |train| block.call(train) } if block_given?
  end

  protected

  attr_reader :train_list

  # private

  # def validate!
  #   # rubocop:disable Style/ZeroLengthPredicate
  #   # if name.length.zero?
  #   #   puts 'Имя станции не может быть пустым.'
  #   #   raise RuntimeError
  #   # end
  #   # rubocop:enable Style/ZeroLengthPredicate
  #   # if name.length < MIN_NAME_LENGTH
  #   #   puts "Имя станции не должно быть меньше #{MIN_NAME_LENGTH} символов."
  #   #   raise RuntimeError
  #   # end
  #   # if name.length > MAX_NAME_LENGTH
  #   #   puts "Имя станции не должно превышать #{MAX_NAME_LENGTH} символов."
  #   #   raise RuntimeError
  #   # end
  #   @@all_stations.each do |station|
  #     if station.name == name
  #       puts 'Станция с таким названием уже существует.'
  #       raise RuntimeError
  #     end
  #   end
  # end
end
