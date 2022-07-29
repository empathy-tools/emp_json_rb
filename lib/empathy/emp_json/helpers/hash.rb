# frozen_string_literal: true

# Adds to_emp_json to Hash
class Hash
  # Converts hash to emp_json
  class EmpConverter
    extend Empathy::EmpJson::Helpers::Primitives

    class << self
      def convert(hash)
        hash.each_with_object({}) do |(key, value), slice|
          slice[key.to_s] = value.transform_keys(&:to_s).transform_values do |v|
            case v
            when Hash
              v
            when Array
              v.map(&method(:object_to_value))
            else
              object_to_value(v)
            end
          end
          slice[key.to_s]["_id"] = object_to_value(key)
          slice
        end
      end
    end
  end

  def to_emp_json
    EmpConverter.convert(self)
  end
end
