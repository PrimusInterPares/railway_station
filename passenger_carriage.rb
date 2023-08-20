# frozen_string_literal: true

# Добавить атрибут общего кол-ва мест (задается при создании вагона)
# Добавить метод, который "занимает места" в вагоне (по одному за раз)
# Добавить метод, который возвращает кол-во занятых мест в вагоне
# Добавить метод, возвращающий кол-во свободных мест в вагоне.

class PassengerCarriage < Carriage
  include Manufacturer

  attr_accessor :seats
  attr_reader :type, :free_seats

  TYPE = :passenger

  def initialize(number_of_seats)
    super()
    @seats = number_of_seats.to_i
    validate!
    @free_seats = number_of_seats.to_i
  end

  def take_seat
    @free_seats -= 1 unless free_seats.zero?
  end

  def release_seat
    @free_seat += 1 if free_seats < seats
  end

  private

  # rubocop:disable Style/GuardClause
  def validate!
    if seats.negative?
      puts 'Количество мест в вагоне не может быть отрицательным.'
      raise RuntimeError
    end
  end
  # rubocop:enable Style/GuardClause
end
