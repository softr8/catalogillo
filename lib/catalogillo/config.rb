require 'singleton'
module Catalogillo
  class Config

    include Singleton
    attr_accessor :per_page,
                  :page,
                  :default_image,
                  :default_product_tile,
                  :default_products_container,
                  :default_search_category,
                  :cache_expires_in
    attr_reader :products_extra_fields

    def initialize
      @per_page = 48
      @page = 1
      @default_image = "catalogillo/no_image.jpg"
      @default_product_tile = {tag: "li", class: "span2"}
      @default_products_container = {tag: "ul", class: "unstyled"}
      @products_extra_fields = []
      @cache_expires_in = 5.minutes
      @default_search_filters = { status: {equal_to: 'active'}, launch_date: {less_than: "FN_TIME_ZONE_NOW" } }
    end

    def products_extra_fields= extras
      extras.each do |field|
        raise ConfigurationException.new("Missing fields") unless (field.keys - [:name, :type, :required, :description]).empty?
      end
      @products_extra_fields = extras
    end

    def search_category
      @search_category ||= Catalogillo::DynamicCategory.filter(filters: { id: 1}).try(:first)
      unless @search_category
        valid_params = {id: 1,
                        name: "Search Results",
                        slug: "search",
                        search_query: ActiveSupport::JSON.encode(@default_search_filters),
                        sorting_options: ActiveSupport::JSON.encode({"price,asc" => {title: "Lowest Price", default: true}}),
                        version: 1}

        @search_category = Catalogillo::DynamicCategory.new valid_params
        Sunspot.index @search_category
      end
      @search_category
    end

    class << self
      def method_missing method, *args
        if instance.respond_to? method
          instance.send(method, *args)
        else
          super(method, *args)
        end
      end
    end
  end
end