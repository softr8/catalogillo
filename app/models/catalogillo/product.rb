module Catalogillo
  class Product < ModelBase

    def self.metadata
      {
          fields: [
              {name: "id", type: "Integer", required: true, desctiption: "unique identifier"},
              {name: "name", type: "String", required: true, desctiption: "Product Name"},
              {name: "category_ids", type: "Integer-Array", required: true, desctiption: "Category Ids"},
              {name: "version", type: "integer", required: true, desctiption: "Current Product Version, expires cache when changed"},
              {name: "pdp_url", type: "String", required: false, desctiption: "Product detail page url"}
          ]
      }
    end

    make_it_searchable

    def self.filter options = {}
      filters = options[:filters] || {}
      Collection.new(search do
        paginate page: options[:page] || Catalogillo::Config.page, per_page: (options[:per_page] || Catalogillo::Config.per_page)
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

  end
end