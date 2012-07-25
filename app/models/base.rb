class Base
  include ActiveModel::Conversion
  include ActiveModel::Validations
  extend ActiveModel::Naming

  attr_accessor :attributes
  attr_accessor :name
  attr_reader :errors

  def initialize(attributes={})
    @attributes = attributes
    @errors = ActiveModel::Errors.new(self)
  end

  def to_param
    id
  end

  def persisted?
    id.present?
  end

  def validate!
    errors.add(:name, "can not be nil") if name == nil
  end

  def read_attribute_for_validation(attr)
    send(attr)
  end

  def method_missing(method, *args)
    @attributes[method.to_s]
  end

  class << self
    def all
      response = Oj.load(Connection.get("/posts.json"))
      response.map do |attributes|
        new(attributes)
      end
    end

    def find(id)
      response = Oj.load(Connection.get("/posts/#{id}.json"))
      new(response)
    end

    def human_attribute_name(attr, options = {})
      attr
    end

    def lookup_ancestors
      [self]
    end
  end
end
