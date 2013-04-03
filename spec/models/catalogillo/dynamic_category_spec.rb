require 'spec_helper'

describe Catalogillo::DynamicCategory do
  let(:valid_params) {
    {
      id: 1,
      name: 'dynamic category',
      slug: 'dynamic-category',
      search_query: ActiveSupport::JSON.encode({category_ids: {less_than: 1007, greater_than: 1007}}),
      version: 1
    }
  }

  context "#query" do
    let(:dynamic_category) { Catalogillo::DynamicCategory.new valid_params }

    it "parses search query" do
      dynamic_category.query["category_ids"].should == {"less_than" => 1007, "greater_than" => 1007}
    end
  end
end