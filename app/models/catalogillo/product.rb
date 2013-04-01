module Catalogillo
  class Product < ModelBase

    def self.metadata
      {
          fields: [
              {name: "id", type: "Integer", required: true, desctiption: "unique identifier"},
              {name: "name", type: "String", required: true, desctiption: "Product Name"},
              {name: "category_id", type: "Integer", required: true, desctiption: "Category Id"},
              {name: "category_name", type: "String", required: true, desctiption: "Category Name"},
              {name: "version", type: "integer", required: true, desctiption: "Current Product Version, expires cache when changed"},
              {name: "pdp_url", type: "String", required: false, desctiption: "Product detail page url"}
          ]
      }
    end

    make_it_searchable

    def self.filter params
      Collection.new(search do
        with(:id, params[:id]) if params.has_key?(:id)
        with(:name, params[:name]) if params.has_key?(:name)
      end)
    end

  end
end