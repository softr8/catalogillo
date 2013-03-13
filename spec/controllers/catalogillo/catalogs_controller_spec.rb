require 'spec_helper'

describe Catalogillo::CatalogsController do
  context "#index" do
    it "returns the true" do
      get :index, action: 'index', slug: "dummy"
      response.should be_ok
    end
  end
end