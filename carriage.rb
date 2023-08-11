# frozen_string_literal: true

class Carriage
  include Manufacturer

  attr_reader :type

  TYPE = :none

  def initialize
    @type = TYPE
  end
end
