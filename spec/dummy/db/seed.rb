product_params =  {version: 1, pdp_url: "http://superhost.com/products/pechan-1", price: 34.56}

puts "Creating Products"
100.times do |index|
  attributes = product_params.merge({id: index,
                                    name: "Product #{index}",
                                    category_ids: [1000 + index, 1000 - index],
                                    fulltext_keywords: "keyword#{index}"})
  Sunspot.index Catalogillo::Product.new attributes
end

puts "Creating Categories..."
Sunspot.index Catalogillo::DynamicCategory.new(id:1, name:"All products", slug:"all", search_query:"{}", version:1)
Sunspot.index Catalogillo::DynamicCategory.new(id:2, name:"Thousand products", slug:"thousand-products", search_query:"{category_ids: {equal_to: 1000}", version:1)