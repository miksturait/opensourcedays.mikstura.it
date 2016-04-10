class ApiObject
  attr_accessor :data_source
  attr_reader :attributes

  def initialize(attributes)
    @attributes = Dish(attributes)
  end

  def self.data_source
    @data_source ||= Api::EventData.new
  end
end
