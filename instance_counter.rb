# frozen_string_literal: true

# Создать модуль InstanceCounter, содержащий следующие методы класса и инстанса, которые подключаются автоматически
# при вызове include в классе:
# Методы класса:
#        - instances, который возвращает кол-во экземпляров данного класса
# Инстанс-методы:
#        - register_instance, увеличивает счетчик кол-ва экземпляров класса и который можно вызвать из конструктора.
# При этом данный метод не должен быть публичным.
# Подключить этот модуль в классы поезда, маршрута и станции.
# Примечание: инстансы подклассов могут считаться по отдельности, не увеличивая счетчик инстансов базового класса.

module InstanceCounter
  def self.included(base)
    base.extend ClassMethods
    base.include InstanceMethods
  end

  module ClassMethods
    attr_writer :instances

    def instances
      @instances ||= 0
    end
  end

  module InstanceMethods
    protected

    def register_instance
      self.class.instances += 1
    end
  end
end
