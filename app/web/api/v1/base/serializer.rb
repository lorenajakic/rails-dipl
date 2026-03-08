# frozen_string_literal: true

module Api
  module V1
    module Base
      class Serializer
        include JSONAPI::Serializer

        # OPTIONAL OVERRIDE
        # for setting types from namespaced serializer class names
        def self.reflected_record_type
          return @reflected_record_type if defined?(@reflected_record_type)

          @reflected_record_type ||= if name&.end_with?('Serializer')
                                       name.remove(/Api::V\d+::|::\w+\z/).singularize.underscore.to_sym
                                     end
        end

        # OPTIONAL OVERRIDE
        # for relationships in namespaced serializers
        # define if you don't want to explicitly specify serializer name for every relationship in serializers
        def self.serializer_for(name) # rubocop:disable Metrics/MethodLength
          namespace = self.name.gsub(/()?\w+::Serializer$/, '')
          serializer_name = "#{name.to_s.classify.pluralize}::Serializer"
          serializer_class_name = namespace + serializer_name
          begin
            serializer_class_name.constantize
          rescue NameError
            raise NameError,
                  "#{self.name} cannot resolve a serializer class for '#{name}'.  " \
                  "Attempted to find '#{serializer_class_name}'. " \
                  'Consider specifying the serializer directly through options[:serializer].'
          end
        end

        # HIGHLY RECOMMENDED OVERRIDE
        # jsonapi-serializer gem loads has_many and has_one relationships by default
        # to render linkages in the response
        # having this override ensures has_manies and has_ones are loaded only when
        # explicitly included
        def self.many?(relationship_name, options = {}, &)
          super(relationship_name, options.reverse_merge(lazy_load_data: true), &)
        end
      end
    end
  end
end
