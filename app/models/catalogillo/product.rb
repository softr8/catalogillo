module Catalogillo
  class Product < ModelBase

    def self.metadata
      {
          fields: [
              {name: "id", type: "Integer", required: true, description: "unique identifier"},
              {name: "name", type: "String", required: true, description: "Product Name"},
              {name: "category_ids", type: "Integer-Array", required: true, description: "Category Ids"},
              {name: "price", type: "float", required: true, description: "Product Price"},
              {name: "sale_price", type: "float", required: false, description: "Product Sale Price"},
              {name: "on_sale", type: "Boolean", required: true, description: "Product Sale Price active?"},
              {name: "version", type: "integer", required: true, description: "Current Product Version, expires cache when changed"},
              {name: "images", type: "String-Array", required: false, description: "Product images"},
              {name: "high_res_images", type: "String-Array", required: false, description: "Product images"},
              {name: "fulltext_keywords", type: "Text", required: false, description: "Product description to be used in searches"},
              {name: "pdp_url", type: "String", required: false, description: "Product detail page url"}
          ]
      }
    end

    make_it_searchable

    def first_thumbnail_image
      images.try(:first).blank? ? Catalogillo::Config.default_image : images.try(:first)
    end

  end
end