require 'singleton'
module Catalogillo
  class Config
    include Singleton
    attr_accessor :per_page, :page, :default_image,
                  :default_product_tile, :default_products_container
    def initialize
      @per_page = 50
      @page = 1
      @default_image = "catalogillo/no_image.jpg"
      @default_product_tile = {tag: "li", class: "span2"}
      @default_products_container = {tag: "ul", class: "unstyled"}
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