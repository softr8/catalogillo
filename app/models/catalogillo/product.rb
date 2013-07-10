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
              {name: "status", type: "String", required: true, description: "Product state"},
              {name: "description", type: "Text", required: false, description: "Product description"},
              {name: "long_description", type: "Text", required: false, description: "Product long description"},
              {name: "launch_date", type: "Time", required: true, description: "Product launch date"},
              {name: "units_on_hand", type: "Integer", required: true, description: "Available units on hand"},
              {name: "variant_sizes", type: "String-Array", required: true, description: "Available sizes"},
              {name: "pdp_url", type: "String", required: false, description: "Product detail page url"}
          ]
      }
    end

    make_it_searchable

    def first_thumbnail_image
      images.try(:first).blank? ? Catalogillo::Config.default_image : images.try(:first)
    end

    def out_of_stock?
      units_on_hand.to_i == 0
    end

    def on_scarce?
      !out_of_stock? && units_on_hand.to_i <= Catalogillo::Config.default_scarcity_level
    end

    def as_json *args
      {
          id: id,
          name: name,
          price: price,
          sale_price: sale_price,
          on_sale: on_sale,
          images: images,
          description: description,
          long_description: long_description,
          out_of_stock: out_of_stock?,
          on_scarce: on_scarce?,
          units_on_hand: on_scarce? ? units_on_hand : 0,
          pdp_url: pdp_url,
          variant_sizes: variant_sizes
      }
    end

    private
    def after_index
      Catalogillo::Category.filter(filters: {id: category_ids}).each do |category|
        category.touch
      end

      Catalogillo::DynamicCategory.filter(filters: {}).each do |category|
        category.touch unless Catalogillo::Product.filter(filters: category.query.merge(id: id)).empty?
      end
      Sunspot.commit
    end
  end
end