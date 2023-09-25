# frozen_string_literal: true

# Написать модуль Acсessors, содержащий следующие методы, которые можно вызывать на уровне класса:

# метод
# attr_accessor_with_history

# Этот метод динамически создает геттеры и сеттеры для любого кол-ва атрибутов, при этом сеттер сохраняет все значения
# инстанс-переменной при изменении этого значения.
# Также в класс, в который подключается модуль должен добавляться инстанс-метод
# <имя_атрибута>_history
# который возвращает массив всех значений данной переменной.

# метод
# strong_attr_accessor

# который принимает имя атрибута и его класс. При этом создается геттер и сеттер для одноименной инстанс-переменной,
# но сеттер проверяет тип присваемоего значения. Если тип отличается от того, который указан вторым параметром,
# то выбрасывается исключение. Если тип совпадает, то значение присваивается.

# Подключить эти модули в свои классы и продемонстрировать их использование.
# Валидации заменить на методы из модуля Validation.

module Accessors
  def attr_accessor_with_history(*attributes)
    attributes.each do |attribute|
      var_name = "@#{attribute}".to_sym
      # getter
      define_method(attribute) { instance_variable_get(var_name) }

      arr_name = "@#{attribute}_his".to_sym
      # setter
      define_method("@#{attribute}=".to_sym) do |value|
        instance_variable_set(arr_name, []) if instance_variable_get(arr_name).nil?
        instance_variable_set(var_name, value)
        instance_variable_get(arr_name) << value
      end

      var_name_history = "@#{attribute}_his".to_sym
      history_method_name = "@#{attribute}_history".to_sym
      define_method(history_method_name) { instance_variable_get(var_name_history) }
    end
  end

  def strong_attr_accessor(attr_name)
    var_name = "@#{attr_name}".to_sym
    # getter
    define_method(attr_name) { instance_variable_get(var_name) }
    # setter
    define_method("@#{attr_name}=".to_sym) do |value|
      var = instance_variable_get(var_name)
      if value.instance_of?(var.class)
        instance_variable_set(var_name, value)
      else
        puts 'Тип присваемого значения не совпадает с типом переменной'
        raise RuntimeError
      end
    end
  end
end
