# frozen_string_literal: true

# Добавить атрибут общего объема (задается при создании вагона)
# Добавить метод, которые "занимает объем" в вагоне (объем указывается в качестве параметра метода)
# Добавить метод, который возвращает занятый объем
# Добавить метод, который возвращает оставшийся (доступный) объем

class CargoCarriage < Carriage
  include Manufacturer

  attr_accessor :volume
  attr_reader :type, :free_volume

  TYPE = :cargo

  def initialize(volume)
    super()
    @volume = volume.to_i
    validate!
    @free_volume = volume.to_i
  end

  def take_volume(taken_volume)
    @free_volume -= taken_volume.to_i if (free_volume - taken_volume.to_i) >= 0
  end

  def free_up_volume(freed_volume)
    @free_volume += freed_volume.to_i if (free_volume + freed_volume.to_i) <= volume
  end

  private

  # rubocop:disable Style/GuardClause
  def validate!
    if volume.zero?
      puts 'Объем вагона не может быть равен 0.'
      raise RuntimeError
    end

    if volume.negative?
      puts 'Объем вагона не может быть отрицательным.'
      raise RuntimeError
    end
  end
  # rubocop:enable Style/GuardClause
end
