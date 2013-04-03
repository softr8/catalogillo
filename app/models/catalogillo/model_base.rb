module Catalogillo
  class ModelBase
    class Error < Exception ; end

    def initialize options
      unless (options.keys.map(&:to_s) & required_fields).size >= required_fields.size
        passed = options.keys.try(:join, ', ')
        passed = passed.blank? ? "none" : passed
        raise Error.new("Missing required attributes, required: #{required_fields.join(', ')}, passed: #{passed}")
      end

      fields.each do |key|
        singleton_class.send(:attr_accessor, key)
        instance_variable_set("@#{key}", "")
      end

      options.each do |key, value|
        instance_variable_set("@#{key}", value)
      end
    end

    include Sunspot::CatalogilloSolr

    def self.filter options = {}
      filters = options[:filters] || {}
      keyword = filters.delete(:keywords)
      Collection.new(search do
        paginate page: options[:page] || Catalogillo::Config.page, per_page: (options[:per_page] || Catalogillo::Config.per_page)

        keywords keyword unless keyword.blank?

        filters.each_pair do |key, value|
          if value.is_a?(Hash)
            any_of do
              value.keys.each do |method|
                with(key).send(method, value[method])
              end
            end
          else
            with(key, value)
          end
        end
      end)
    end

    def self.usage
      metadata
    end

    class Collection
      include Enumerable
      extend Forwardable
      attr_reader :collection

      def_delegators :to_ary, :each

      def initialize search
        @collection = search.hits
      end

      def to_ary
        @result_hit_collection ||= @collection.map do |hit|
          klass = hit.class_name.constantize
          attributes = {}
          klass.metadata[:fields].collect {|field| field[:name]}.each do |field_name|
            attributes[field_name] = hit.stored(field_name)
          end
          klass.new(attributes)
        end
      end

    end

    private

    def required_fields
      @required_fields ||= singleton_class.metadata[:fields].select {|field| field[:required] }.collect {|field| field[:name]}
    end

    def fields
      @fields ||= singleton_class.metadata[:fields].collect {|field| field[:name]}
    end
  end
end