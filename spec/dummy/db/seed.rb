product_params =  {version: 1, pdp_url: "http://superhost.com/products/pechan-1", on_sale: false}

puts "Creating Products"
100.times do |index|
  attributes = product_params.merge({id: index,
                                    name: "Product #{index}",
                                    category_ids: [1000 + index, 1000 - index, [20000, 20001, 20002, 20003].sample],
                                    price: 30.45 + index,
                                    fulltext_keywords: "keyword#{index}",
                                    status: 'active',
                                    launch_date: index.days.ago})
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

Catalogillo::Category.new({id: 20000, name: "category one", slug: "category-one", left_id: 1, right_id: 4, parent_id: nil, version: 1}).index
Catalogillo::Category.new({id: 20001, name: "category one - one", slug: "category-one-one", left_id: 2, right_id: 3, parent_id: 1000, version: 1}).index
Catalogillo::Category.new({id: 20002, name: "category two", slug: "category-two", left_id: 5, right_id: 8, parent_id: nil, version: 1}).index
Catalogillo::Category.new({id: 20003, name: "category two - one", slug: "category-two-one", left_id: 6, right_id: 7, parent_id: nil, version: 1}).index

Sunspot.commit