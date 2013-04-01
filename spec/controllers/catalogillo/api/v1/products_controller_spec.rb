require 'spec_helper'

describe Catalogillo::Api::V1::ProductsController do

  context "#index" do
    let(:valid_params) {
      {
          products: [
              {id: 1, name: 'Pechan 1', version: 1, category_ids: [1000], category_name: "Category One", pdp_url: "http://superhost.com/products/pechan-1"},
              {id: 2, name: 'Pechan 2', version: 1, category_ids: [1001], category_name: "Category One - One", pdp_url: "http://superhost.com/products/pechan-2"}
          ]
      }
    }
    it "returns ok if solr commit succeeds" do
      post :index, valid_params
      response.should be_ok
    end

    it "returns unprocessable entity if solr commit fails " do
      post :index, {products: [{id: 1}]}
      response.code.should eql("422")
    end

    it "returns errors when required fields are not passed" do
      post :index, {products: [{id: 1}]}
      response.body.should =~ /Missing required attributes, required: id, name, category_ids, version/
    end

    context "indexes new products" do
      subject { Catalogillo::Product.filter(id: 1).first }
      before do
        post :index, valid_params
      end

      its(:name) { should == "Pechan 1" }
      its(:version) { should == 1 }
      its(:category_ids) { should == [1000] }
      its(:pdp_url) { should == "http://superhost.com/products/pechan-1" }
    end
  end

  context "#destroy" do
    it "removes a record from the index" do
      Sunspot.should_receive(:remove).with(Catalogillo::Product).and_return(true)
      delete :destroy, id: 99
      response.should be_ok
    end
    it "removes a record from the index and return an error if it fails" do
      Sunspot.should_receive(:remove).with(Catalogillo::Product).and_return(false)
      delete :destroy, id: 99
      response.code.should eql("422")
    end
  end
end