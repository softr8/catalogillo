require 'spec_helper'

describe Catalogillo::CategoriesController do
  context "#index" do
    it "returns the true" do
      get :index, slug: "dummy"
      response.code.should == "404"
    end
  end

  context "#search" do
    it "returns correct response" do
      get :search, keyword: 'product'
      response.should be_ok
    end

    it "filters by keywords" do
      product = Catalogillo::Product.filter(filters: {}).first
      product.fulltext_keywords = "product1"
      product.name = "Product 1"
      Sunspot.index! product
      get :search, keyword: 'product1 '
      assigns(:hits).first.name.should == "Product 1"
    end
  end
end