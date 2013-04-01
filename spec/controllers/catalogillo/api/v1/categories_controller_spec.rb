require 'spec_helper'

describe Catalogillo::Api::V1::CategoriesController do

  context "POST #index" do
    let(:valid_params) {
      { categories: [
          {id: 1000, name: "category one", slug: "category-one", ancestry_id: nil, version: 1},
          {id: 1001, name: "category one - one", slug: "category-one-one", ancestry_id: 1000, version: 1}
      ]}
    }

    it "returns ok if solr commit succeeds" do
      post :index, valid_params
      puts response.body
      response.should be_ok
    end

    it "returns unprocessable entity if solr commit fails " do
      post :index, {categories: [{id: 1}]}
      response.code.should eql("422")
    end

    it "returns errors when required fields are not passed" do
      post :index, {categories: [{id: 1}]}
      response.body.should =~ /Missing required attributes, required: id, name, ancestry_id, slug, version/
    end

    context "indexes new records" do
      subject { Catalogillo::Category.filter(id: 1000).first }
      before do
        post :index, valid_params
      end

      its(:name) { should == "category one" }
      its(:version) { should == 1 }
      its(:slug) { should == "category-one" }
      its(:ancestry_id) { should == nil }
    end
  end

  context "DELETE #destroy" do
    it "removes a record from the index" do
      Sunspot.should_receive(:remove).with(Catalogillo::Category).and_return(true)
      delete :destroy, id: 1000
      response.should be_ok
    end
    it "removes a record from the index and return an error if it fails" do
      Sunspot.should_receive(:remove).with(Catalogillo::Category).and_return(false)
      delete :destroy, id: 99
      response.code.should eql("422")
    end

  end
end