require 'spec_helper'

describe Catalogillo::Api::V1::DynamicCategoriesController do

  context "POST #index" do
    let(:filtered_one) {
      {dynamic_category:
           {id: 1, name: "filtered one", slug: "filtered-one", search_query: "{\"category_ids\":[1000,1001]}", version: 1}
      }
    }
    let(:filtered_two) {
      {dynamic_category:
           {id: 2, name: "filtered two", slug: "filtered-two", search_query: "{\"name\":\"filtered two\"}", version: 1}
      }
    }

    it "returns ok if solr commit succeeds" do
      post :index, filtered_one
      response.should be_ok
    end

    it "returns unprocessable entity if solr commit fails " do
      post :index, dynamic_category: {name: "super name"}
      response.code.should eql("422")
    end

    it "returns errors when required fields are not passed" do
      post :index, dynamic_category: {name: "super name"}
      response.body.should =~ /Missing required attributes, required: id, name, slug, search_query, version, passed/
    end

    context "indexes new dynamic category" do
      subject { Catalogillo::DynamicCategory.filter(name: "filtered two").first }
      before do
        post :index, filtered_two
      end

      its(:name) { should == "filtered two" }
      its(:version) { should == 1 }
      its(:slug) { should == "filtered-two" }
      its(:search_query) { should == "{\"name\":\"filtered two\"}" }
    end
  end
end