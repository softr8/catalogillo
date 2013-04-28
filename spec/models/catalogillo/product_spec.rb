require 'spec_helper'

describe Catalogillo::Product do
  context ".filter" do
    let(:valid_params) {
      {version: 1, pdp_url: "http://superhost.com/products/pechan-1", price: 34.56, on_sale: false, status: 'active', launch_date: 1.day.ago, variant_sizes: ['S', 'M', 'L']}
    }
    before :all do
      10.times do |index|
        Sunspot.index Catalogillo::Product.new valid_params.merge(id: index,
                                                                  name: "Product #{index}",
                                                                  category_ids: [1000 + index, 1000 - index],
                                                                  fulltext_keywords: "keyword#{index}",
                                                                  units_on_hand: index
                                               )
      end
      Sunspot.commit
    end
    describe "with id" do
      it "filters by specific id" do
        product = Catalogillo::Product.filter(filters: {id: 1}).first
        product.name.should == "Product 1"
      end
    end

    describe "starting name with" do
      it "filters by product name" do
        product = Catalogillo::Product.filter(filters: {name: {starting_with: 'Product 1'}}).first
        product.name.should =~ /Product 1/
      end
    end

    describe "category id greater than" do
      it "finds products with price greater or equal than" do
        products = Catalogillo::Product.filter(filters: {price: {greater_than_or_equal_to: 50}})
        products.map(&:price).each do |price|
          price.should >= 50
        end
      end
    end

    describe "category id between" do
      it "filters 1006 and 1007 categories ids" do
        products = Catalogillo::Product.filter(filters: {category_ids: {between: [1006, 1007]}})
        products.map(&:name).should == ["Product 6", "Product 7"]
      end
    end

    describe "category ids as array" do
      it "filters by hierachical data" do
        products = Catalogillo::Product.filter(filters: {category_ids: {equal_to: [1005, 1007]}})
        products.map(&:name).should == ["Product 5", "Product 7"]
      end
    end

    describe "composed filters" do
      before do
        Sunspot.index! Catalogillo::Product.new valid_params.merge(id: 7, name: "Product 7", category_ids: [1007], units_on_hand: 10)
      end
      it "filters out based on multiple filters" do
        products = Catalogillo::Product.filter(filters: {category_ids: {less_than: 1007, greater_than: 1007}})
        products.map(&:name).should_not include "Product 7"
      end
    end

    describe "lambda conditions" do
      products = Catalogillo::Product.filter(filters: {launch_date: {less_than: 'FN_TIME_ZONE_NOW'}})
      products.map(&:name).should_not == "Product 7"
    end

    describe "pagination" do
      it "paginates results" do
        products = Catalogillo::Product.filter(per_page: 3)
        products.count.should == 3
      end
    end

    describe "fulltext search" do
      it "filters based on keywords" do
        products = Catalogillo::Product.filter(filters: {keywords: "keyword1"})
        products.first.name.should == "Product 1"
      end
    end
  end

  context "extra fields" do
    context "invalid params" do
      it "raises an exception" do
        expect do
          Catalogillo::Config.products_extra_fields = [
              {"wrong" => "key"}
          ]
        end.to raise_exception(Catalogillo::ConfigurationException)
      end
    end

    context "Valid params" do
      before :all do
        Catalogillo::Config.products_extra_fields = [
            {name: "custom_field", type: "String", required: false, description: "Extra custom field"}
        ]
      end

      it "creates a new product including custom_field" do
        valid_params = {
            id: 9876,
            name: "Custom Product",
            category_ids: [1000],
            version: 1,
            pdp_url: 'url',
            price: 12.34,
            on_sale: false,
            custom_field: "custom field",
            status: 'active',
            launch_date: 1.day.ago,
            units_on_hand: 5,
            variant_sizes: ['XL']
        }
        product = Catalogillo::Product.new valid_params
        product.custom_field.should == "custom field"
      end
    end
  end

  context "#after_initialize" do
    let(:product_params) do
      {version: 1,
       pdp_url: "http://superhost.com/products/cache-1",
       price: 34.56,
       on_sale: false,
       status: 'active',
       launch_date: 1.day.ago,
       id: 5678,
       name: "Product Cache",
       category_ids: [1000],
       fulltext_keywords: "",
       units_on_hand: 5,
       variant_sizes: ['XL']
      }
    end

    context "cache" do
      let(:category) { double(Catalogillo::Category, {touch: true}) }
      let(:dynamic_category) { double(Catalogillo::DynamicCategory, {touch: true, query: {}}) }
      it "updates category version" do
        Catalogillo::Category.stub(:filter).with(any_args).and_return([category])
        category.should_receive(:touch)
        Catalogillo::Product.new product_params
      end

      it "updates dyamic category version" do
        Catalogillo::DynamicCategory.stub(:filter).with(any_args).and_return([dynamic_category])
        Catalogillo::Product.stub(:filter).with(any_args).and_return([1])
        dynamic_category.should_receive(:touch)
        Catalogillo::Product.new product_params
      end
    end
  end
end