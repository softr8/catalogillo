require 'spec_helper'


describe Catalogillo::Api::V1::CatalogsController do

  context "#index" do
    it "returns ok if solr commit succeeds" do
      post :index, {products: [{id: 1, name: 'Pechan 1', version: 1}, {id: 2, name: 'Pechan 2', version: 1}]}
      response.should be_ok
    end

    it "returns unprocessable entity if solr commit fails " do
      post :index, {products: [{id: 1}]}
      response.code.should eql("422")
      puts response.body
    end

    it "returns errors when required fields are not passed" do
      post :index, {products: [{id: 1}]}
      response.body.should =~ /Missing required attributes, required: id, name, passed: id/
    end

    it "indexes new products" do
      post :index, {products: [{id: 1, name: 'Pechan 1', version: 1}, {id: 2, name: 'Pechan 2', version: 1}]}
      results = Catalogillo::Product.filter id: 1
      results.first.name.should == "Pechan 1"
    end
  end
end