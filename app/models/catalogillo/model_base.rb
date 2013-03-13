module Catalogillo
  class ModelBase
    class Error < Exception ; end

    def initialize options
      unless ((options.keys || []) & required_fields).size >= required_fields.size
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
          ResultHit.new(hit)
        end
      end

    end

    class ResultHit
      attr_accessor :hit

      def initialize hit
        @hit = hit
      end

      def method_missing name, *args
        hit.stored(name) rescue super(*args)
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