require 'spec_helper'

describe Catalogillo::Product do
  let(:valid_params) {
    {version: 1, pdp_url: "http://superhost.com/products/pechan-1"}
  }
  before :all do
    10.times { |index| Sunspot.index Catalogillo::Product.new valid_params.merge(id: index, name: "Product #{index}", category_ids: [1000 + index, 1000 - index]) }
    Sunspot.commit
  end

  context ".filter" do
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
      it "finds products with category_id 1009" do
        product = Catalogillo::Product.filter(filters: { category_ids: {greater_than_or_equal_to: 1009}}).first
        product.name.should == "Product 9"
      end
    end

    describe "category id between" do
      it "filters 1006 and 1007 categories ids" do
        products = Catalogillo::Product.filter(filters: {category_ids: {between: 1006..1007}})
        products.map(&:name).should == ["Product 6", "Product 7"]
      end
    end

    describe "composed filters" do
      before do
        Sunspot.index! Catalogillo::Product.new valid_params.merge(id: 7, name: "Product 7", category_ids: [1007])
      end
      it "filters out based on multiple filters" do
        products = Catalogillo::Product.filter(filters: {category_ids: {less_than: 1007, greater_than: 1007}})
        products.map(&:name).should_not include "Product 7"
      end
    end

    describe "pagination" do
      it "paginates results" do
        products = Catalogillo::Product.filter(per_page: 3)
        products.count.should == 3
      end
    end
  end
end