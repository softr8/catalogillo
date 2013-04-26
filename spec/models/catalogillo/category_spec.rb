require 'spec_helper'

describe Catalogillo::Category do

  before :all do
    Catalogillo::Category.new({id: 1000, name: "category one", slug: "category-one", left_id: 1000, right_id: 1004, parent_id: nil, version: 1}).index!
    Catalogillo::Category.new({id: 1001, name: "category one - one", slug: "category-one-one", left_id: 1002, right_id: 1003, parent_id: 1000, version: 1}).index!
  end

  let(:category) {
    Catalogillo::Category.filter(filters: {id: 1000}).first
  }
  context "#query" do
    it "returns ids 1000 and 1001" do
      category.query[:category_ids].should == {equal_to: [1000, 1001]}
    end
  end

  #context "#sort_by" do
  #  it "returns array with sorting options" do
  #    dynamic_category.sort_by("price,asc").should == ["price", :asc]
  #  end
  #
  #  it "returns the default sorting" do
  #    dynamic_category.sort_by.should == ["price", :asc]
  #  end
  #
  #  it "returns the default sorting if wrong sorting options are passed" do
  #    dynamic_category.sort_by('aksdlfkjasldkfj').should == ["price", :asc]
  #  end
  #end
end