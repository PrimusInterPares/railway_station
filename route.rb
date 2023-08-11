# Класс Route (Маршрут):
# Имеет начальную и конечную станцию, а также список промежуточных станций. Начальная и конечная станции указываютсся
# при создании маршрута, а промежуточные могут добавляться между ними.
# Может добавлять промежуточную станцию в список
# Может удалять промежуточную станцию из списка
# Может выводить список всех станций по-порядку от начальной до конечной

require_relative 'instance_counter'

class Route
  include InstanceCounter
  attr_reader :stations

  def initialize(starting_station, terminal_station)
    @stations = [starting_station, terminal_station]
    register_instance
  end

  def add_station(station)
    stations.insert(-2, station)
  end

  def delete_station(station)
    stations.delete(station) if station != stations.first && station != stations.last
  end

  def print_station_list
    stations.each { |station| puts station.name }
  end

  def next_station(current_station)
    stations[stations.find_index(current_station) + 1]
  end

  def previous_station(current_station)
    stations[stations.find_index(current_station) - 1]
  end

  def first
    stations.first
  end

  def last
    stations.last
  end

  def last?(station)
    stations.find { |elem| elem == station } == last
  end

  def first?(station)
    stations.find { |elem| elem == station } == first
  end
end
