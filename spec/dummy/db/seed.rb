product_params =  {version: 1, pdp_url: "http://superhost.com/products/pechan-1", on_sale: false}

puts "Creating Products"
100.times do |index|
  attributes = product_params.merge({id: index,
                                    name: "Product #{index}",
                                    category_ids: [1000 + index, 1000 - index],
                                    price: 30.45 + index,
                                    fulltext_keywords: "keyword#{index}"})
  Sunspot.index Catalogillo::Product.new attributes
end

puts "Creating Categories..."
Sunspot.index Catalogillo::DynamicCategory.new(id:10001,
                                               name:"All products",
                                               slug:"all",
                                               search_query:"{}",
                                               sorting_options: ActiveSupport::JSON.encode({"price,asc" => {title: "Lowest Price", default: true},
                                                                                            "price,desc" => {title: "Highest Price"}}),
                                               version:1)
Sunspot.index Catalogillo::DynamicCategory.new(id:10002,
                                               name:"Thousand products",
                                               slug:"thousand-products",
                                               search_query: ActiveSupport::JSON.encode({category_ids: {equal_to: 1000}}),
                                               sorting_options: ActiveSupport::JSON.encode({"price,asc" => {title: "Lowest Price", default: true},
                                                                                            "price,desc" => {title: "Highest Price"}}),
                                               version:1)