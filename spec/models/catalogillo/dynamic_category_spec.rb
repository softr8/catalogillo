require 'spec_helper'

describe Catalogillo::DynamicCategory do
  let(:valid_params) {
    {
        id: 2,
        name: 'dynamic category',
        slug: 'dynamic-category',
        search_query: ActiveSupport::JSON.encode({category_ids: {less_than: 1007, greater_than: 1007}}),
        sorting_options: ActiveSupport::JSON.encode({"price,asc" => {title: "Lowest Price", default: true},
                                                     "price,desc" => {title: "Highest Price"}}),
        version: 1
    }
  }

  let(:dynamic_category) { Catalogillo::DynamicCategory.new valid_params }

  context "#query" do

    it "parses search query" do
      dynamic_category.query["category_ids"].should == {"less_than" => 1007, "greater_than" => 1007}
    end
  end

  context "#sort_by" do
    it "returns array with sorting options" do
      dynamic_category.sort_by("price,asc").should == ["price", :asc]
    end

    it "returns the default sorting" do
      dynamic_category.sort_by.should == ["price", :asc]
    end

    it "returns the default sorting if wrong sorting options are passed" do
      dynamic_category.sort_by('aksdlfkjasldkfj').should == ["price", :asc]
    end
  end
end