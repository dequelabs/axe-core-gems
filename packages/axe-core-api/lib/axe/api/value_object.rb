module Axe
  module API
    class ValueObject
      class << self
        def attributes
          @attributes ||= superclass.respond_to?(:attributes) ? superclass.attributes.dup : {}
        end

        def values(&block)
          instance_eval(&block)
        end

        def attribute(name, type = nil)
          attributes[name] = type
          attr_reader(name) unless method_defined?(name)
        end
      end

      def initialize(attrs = {})
        attrs ||= {}
        self.class.attributes.each do |name, type|
          raw = if attrs.key?(name)
                  attrs[name]
                elsif attrs.key?(name.to_s)
                  attrs[name.to_s]
                end
          instance_variable_set("@#{name}", coerce(raw, type))
        end
      end

      def to_h
        self.class.attributes.each_key.each_with_object({}) do |name, hash|
          hash[name] = public_send(name)
        end
      end

      def ==(other)
        other.is_a?(self.class) && to_h == other.to_h
      end
      alias_method :eql?, :==

      def hash
        [self.class, to_h].hash
      end

      private

      def coerce(value, type)
        return value if type.nil?

        case type
        when Array
          Array(value).map { |element| coerce(element, type.first) }
        when Class
          coerce_class(value, type)
        else
          value
        end
      end

      def coerce_class(value, type)
        return nil if value.nil?

        if type == ::Symbol
          value.to_sym
        elsif type == ::String
          value.to_s
        elsif type <= ValueObject
          value.is_a?(ValueObject) ? value : type.new(value)
        else
          value
        end
      end
    end
  end
end
