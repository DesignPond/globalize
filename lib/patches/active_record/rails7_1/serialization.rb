module Globalize
  module AttributeMethods
    module Serialization
      def serialize(attr_name, class_name_or_coder = Object, coder: nil, **options)
        if coder
          super(attr_name, coder: coder, **options)
        else
          super(attr_name, class_name_or_coder, **options)

          coder = if class_name_or_coder == ::JSON
                    ::ActiveRecord::Coders::JSON
                  elsif [:load, :dump].all? { |x| class_name_or_coder.respond_to?(x) }
                    class_name_or_coder
                  else
                    ::ActiveRecord::Coders::YAMLColumn.new(attr_name, class_name_or_coder)
                  end

          self.globalize_serialized_attributes = globalize_serialized_attributes.dup
          self.globalize_serialized_attributes[attr_name] = coder
        end
      end
    end
  end
end
