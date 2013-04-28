require 'spec_helper'

describe Catalogillo::Api::V1::ProductsController do

  context "#index" do
    let(:valid_params) {
      {
          products: [
              {id: 2, name: 'Pechan 2', version: 1, category_ids: [1000], pdp_url: "http://superhost.com/products/pechan-2", price: 45.65, on_sale: false, status: 'active', launch_date: 1.day.ago, units_on_hand: 10, variant_sizes: ['5','6']},
              {id: 3, name: 'Pechan 3', version: 1, category_ids: [1001], pdp_url: "http://superhost.com/products/pechan-3", price: 34.34, on_sale: false, status: 'active', launch_date: 1.day.ago, units_on_hand: 10, variant_sizes: ['5','6']}
          ]
      }
    }
    it "returns ok if solr commit succeeds" do
      post :index, valid_params
      response.should be_ok
    end

    it "returns unprocessable entity if solr commit fails " do
      post :index, {products: [{id: 2}]}
      response.code.should eql("422")
    end

    it "returns errors when required fields are not passed" do
      post :index, {products: [{id: 1}]}
      response.body.should =~ /Missing required attributes, required: id, name, category_ids, price, on_sale, version, status/
    end

    context "indexes new products" do
      subject { Catalogillo::Product.filter(filters: {id: 2}).first }
      before do
        post :index, valid_params
      end

      its(:name) { should == "Pechan 2" }
      its(:version) { should == 1 }
      its(:category_ids) { should == [1000] }
      its(:pdp_url) { should == "http://superhost.com/products/pechan-2" }
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