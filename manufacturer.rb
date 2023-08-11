# Создать модуль, который позволит указывать название компании-производителя и получать его. Подключить модуль к классам Вагон и Поезд

module Manufacturer
  def manufacturer_name=(name)
    self.name = name
  end

  def manufacturer_name
    self.name
  end

  protected

  attr_accessor :name
end
