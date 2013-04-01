module Sunspot
  module CatalogilloSolr
    def self.included(base)
      base.class_eval do
        extend Sunspot::Rails::Searchable::ActsAsMethods
        extend MakeItSearchable
        Sunspot::Adapters::DataAccessor.register(DataAccessor, base)
        Sunspot::Adapters::InstanceAdapter.register(InstanceAdapter, base)
      end
    end

    module MakeItSearchable
      def make_it_searchable
        searchable(auto_index: false, auto_remove: false) do
          metadata[:fields].each do |field|
            field_type, field_mode = field[:type].split('-')
            send field_type.downcase, field[:name], stored: true, multiple: field_mode.eql?("Array")
          end
        end
      end
    end

    class InstanceAdapter < ::Sunspot::Adapters::InstanceAdapter
      def id
        @instance.id
      end
    end

    class DataAccessor < ::Sunspot::Adapters::DataAccessor
      def load(id)
      end

      def load_all(ids)
      end
    end

  end
end
