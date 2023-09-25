# frozen_string_literal: true

# Написать модуль Validation, который:

# Содержит метод класса validate. Этот метод принимает в качестве параметров имя проверяемого атрибута,
# а также тип валидации и при необходимости дополнительные параметры. Возможные типы валидаций:
#  - presence - требует, чтобы значение атрибута было не nil и не пустой строкой. Пример использования:
# validate :name, :presence

#  - format (при этом отдельным параметром задается регулярное выражение для формата).
# Треубет соответствия значения атрибута заданному регулярному выражению. Пример:
# validate :number, :format, /A-Z{0,3}/

#  - type (третий параметр - класс атрибута). Требует соответствия значения атрибута заданному классу. Пример:
# validate :station, :type, RailwayStation

# Содержит инстанс-метод validate!, который запускает все проверки (валидации),
# указанные в классе через метод класса validate.
# В случае ошибки валидации выбрасывает исключение с сообщением о том, какая именно валидация не прошла
# Содержит инстанс-метод valid? который возвращает true, если все проверки валидации прошли успешно и false,
# если есть ошибки валидации.

# К любому атрибуту можно применить несколько разных валидаторов, например
# validate :name, :presence
# validate :name, :format, /A-Z/
# validate :name, :type, String
# Все указанные валидаторы должны применяться к атрибуту
# Допустимо, что модуль не будет работать с наследниками.

# Подключить эти модули в свои классы и продемонстрировать их использование.
# Валидации заменить на методы из модуля Validation.

module Validation
  def self.included(base)
    base.extend ClassMethods
    base.include InstanceMethods
  end

  module ClassMethods
    def validate(attribute, validation_type, params = nil)
      @validations ||= []
      @validations.push({ attribute:, validation_type:, params: })
    end

    def clear
      @validations = []
    end
  end

  module InstanceMethods
    def validate!
      validations = self.class.instance_variable_get(:@validations)
      validations.each do |validation|
        send("validate_#{validation[:validation_type]}", validation[:attribute], validation[:params])
      end
    end

    def valid?
      validate!
    rescue RuntimeError => e
      puts "Error: #{e.message}"
      false
    else
      true
    end

    # rubocop:disable Style/GuardClause
    def validate_presence(variable, _)
      if variable.nil? || variable == ''
        puts 'Имя не может быть пустой строкой или nil'
        raise RuntimeError
      end
    end

    def validate_format(variable, format)
      unless variable =~ format
        puts 'Формат номера задан неверно!'
        puts 'Допустимый формат: XX-XX или XXXX, где Х любая буква или цифра.'
        raise RuntimeError
      end
    end

    def validate_type(variable, type)
      unless variable.is_a?(type)
        puts 'Классы объектов не совпадают'
        raise RuntimeError
      end
    end

    def validate_min_length(variable, min_length)
      if variable.length < min_length
        puts "Длина не должна быть меньше #{min_length} символов."
        raise RuntimeError
      end
    end

    def validate_max_length(variable, max_length)
      if variable.length > max_length
        puts "Длина не должна превышать #{max_length} символов."
        raise RuntimeError
      end
    end
    # rubocop:enable Style/GuardClause
  end
end
