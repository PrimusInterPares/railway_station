# x Разбить программу на отдельные классы (каждый класс в отдельном файле)
# Разделить поезда на два типа PassengerTrain и CargoTrain, сделать родителя для классов, который будет содержать общие
# методы и свойства
# Определить, какие методы могут быть помещены в private/protected и вынести их в такую секцию. В комментарии к методу
# обосновать, почему он был вынесен в private/protected
# Вагоны теперь делятся на грузовые и пассажирские (отдельные классы). К пассажирскому поезду можно прицепить только
# пассажирские, к грузовому - грузовые.
# При добавлении вагона к поезду, объект вагона должен передаваться как аргумент метода и сохраняться во внутреннем массиве поезда,
# в отличие от предыдущего задания, где мы считали только кол-во вагонов. Параметр конструктора "кол-во вагонов" при этом можно удалить.

# Добавить текстовый интерфейс:

# Создать программу в файле main.rb, которая будет позволять пользователю через текстовый интерфейс делать следующее:
#      - Создавать станции
#      - Создавать поезда
#      - Создавать маршруты и управлять станциями в нем (добавлять, удалять)
#      - Назначать маршрут поезду
#      - Добавлять вагоны к поезду
#      - Отцеплять вагоны от поезда
#      - Перемещать поезд по маршруту вперед и назад
#      - Просматривать список станций и список поездов на станции

require 'pry'

require_relative 'station'
require_relative 'train'
require_relative 'route'
require_relative 'passenger_train'
require_relative 'passenger_carriage'
require_relative 'carriage'
require_relative 'cargo_carriage'
require_relative 'cargo_train'
require_relative 'instance_counter'
require_relative 'manufacturer'

class Main
  attr_accessor :trains, :stations, :route, :carriages

  def initialize
    @trains = []
    @stations = []
    @route = nil
  end

  def create_station
    attempt = 0
    begin
      print 'Введите имя станции (от 3 до 15 символов): '
      name = gets.chomp

      stations.push(Station.new(name))

      print "Создана станция #{stations.last.name}.\n"
    rescue RuntimeError
      attempt += 1
      puts 'Попытайтесь еще раз.'
      retry if attempt < 3
    end

    puts 'Исчерпано количество попыток создать станцию.' if attempt == 3
  end

  def create_train
    attempt = 0
    begin
      print 'Введите номер поезда в формате XX-XX или XXXX, где Х любая буква или цифра: '
      number = gets.chomp

      return puts 'Такой поезд уже существует.' if trains.find { |elem| elem.number == number }

      print 'Введите тип поезда (\'грузовой\' или \'пассажирский\'): '
      type = gets.chomp

      print 'Введите количество вагонов: '
      carriages = gets.chomp.to_i

      if type == 'грузовой'
        train = CargoTrain.new(number)

        1.upto(carriages) do
          carriage = CargoCarriage.new
          train.attach_carriage(carriage)
        end

        trains.push(train)
        
        print "Создан поезд №#{trains.last.number}, тип #{type}, #{carriages} вагонов.\n"
      elsif type == 'пассажирский'
        train = PassengerTrain.new(number)

        1.upto(carriages) do
          carriage = PassengerCarriage.new
          train.attach_carriage(carriage)
        end

        trains.push(train)

        print "Создан поезд №#{trains.last.number}, тип #{type}, #{carriages} вагонов.\n"
      else
        puts 'Неверный тип вагона.'
        raise RuntimeError
      end
    rescue RuntimeError
      attempt += 1
      puts 'Попытайтесь еще раз.'
      retry if attempt < 3
    end

    puts 'Исчерпано количество попыток создать поезд.' if attempt == 3
  end

  def create_route
    print 'Введите начало маршрута: '
    route_start = gets.chomp

    print 'Введите конец маршрута: '
    route_end = gets.chomp

    starting_station = stations.find { |elem| elem.name == route_start }
    terminal_station = stations.find { |elem| elem.name == route_end }
    @route = Route.new(starting_station, terminal_station)

    puts 'Маршрут создан'
  end

  def add_station_into_route
    return puts 'Маршрут не создан.' if route.nil?

    print 'Введите имя добавляемой в маршрут станции: '
    station_name = gets.chomp

    station = stations.find { |elem| elem.name == station_name }
    route.add_station(station)

    print "Станция #{route.stations[-2].name} добавлена в маршрут.\n"
  end

  def remove_station_from_route
    return puts 'Маршрут не создан.' if route.nil?

    print 'Введите имя удаляемой станции: '
    station = gets.chomp

    route.delete_station(station)

    print "Станция #{station} удалена.\n"
  end

  def assign_route_to_train
    return  puts 'Маршрут не создан.' if route.nil?

    print 'Введите номер поезда: '
    train_number = gets.chomp

    train = trains.find { |elem| elem.number == train_number }
    return  puts 'Нет такого поезда.' if train.nil?

    train.route = route

    print "Поезду #{train.number} назначен маршрут.\n"
  end

  def attach_carriage_to_train
    print 'Введите номер поезда: '
    train_number = gets.chomp

    train = trains.find { |elem| elem.number == train_number }
    return puts 'Нет такого поезда.' if train.nil?

    carriage = Carriage.new
    train.attach_carriage(carriage)
  end

  def uncouple_carriage_from_train
    print 'Введите номер поезда: '
    train_number = gets.chomp

    train = trains.find { |elem| elem.number == train_number }
    puts 'Нет такого поезда.' if train.nil?
  end

  def move_train_forward
    print 'Введите номер поезда: '
    train_number = gets.chomp

    train = trains.find { |elem| elem.number == train_number }
    return puts 'Нет такого поезда.' if train.nil?

    return puts 'Поезду не назначен маршрут.' if train.current_station.nil?

    train.move_to_next_station

    puts "Поезд #{train.number} передвинут на следующую станцию #{train.current_station.name}."
  end

  def move_train_back
    print 'Введите номер поезда: '
    train_number = gets.chomp

    train = trains.find { |elem| elem.number == train_number }
    return puts 'Нет такого поезда.' if train.nil?

    return puts 'Поезду не назначен маршрут.' if train.current_station.nil?

    train.move_to_previous_station

    puts "Поезд #{train.number} передвинут на предыдущую станцию #{train.current_station.name}."
  end

  def list_stations
    puts 'Станции:'
    stations.each { |stat| puts " - #{stat.name}" }
  end

  def train_list_on_station
    print 'Введите имя станции: '
    station_name = gets.chomp

    station = stations.find { |elem| elem.name == station_name }
    return puts 'Нет такой станции.' if station.nil?

    puts 'Поезда:'
    trains.each { |elem| puts " - #{elem.number}" if elem.current_station == station }
  end

  puts ' - Для создания станции введите 1'
  puts ' - Для создания поезда введите 2'
  puts ' - Для создания маршрута введите 3'
  puts ' - Для добавления станции в маршрут введите 4'
  puts ' - Для назначения маршрута поезду введите 6'
  puts ' - Для добавления вагона к поезду введите 7'
  puts ' - Для отцепления вагона от поезда введите 8'
  puts ' - Для перемещения поезда по маршруту вперед введите 9'
  puts ' - Для перемещения поезда по маршруту назад введите 10'
  puts ' - Для просмотра списка станций введите 11'
  puts ' - Для просмотра списка поездов на станции введите 12'
  puts ' - Выход - 0'

  main = Main.new

  action = 666
  until action.zero?
    print "\nВведите команду: "
    action = gets.to_i
    case action
    when 1 # Создать станцию
      main.create_station
    when 2 # Создать поезд
      main.create_train
    when 3 # Создать маршрут
      main.create_route
    when 4 # Добавить станцию в маршрут
      main.add_station_into_route
    when 5 # Удалить станцию из маршрута
      main.remove_station_from_route
    when 6 # Назначать маршрут поезду
      main.assign_route_to_train
    when 7 # Добавить вагон поезду
      main.attach_carriage_to_train
    when 8 # Отцепить вагон от поезда
      main.uncouple_carriage_from_train
    when 9 # Переместить поезд по маршруту вперед
      main.move_train_forward
    when 10 # Переместить поезд по маршруту назад
      main.move_train_back
    when 11 # Просмотреть список станций
      main.list_stations
    when 12 # Посмотреть список поездов на станции
      main.train_list_on_station
    when 0 # Выход
      puts "\nДо свидания!"
    else
      puts 'Неизвестная команда.'
    end
  end
end
