module Catalogillo
  class CatalogsController < ApplicationController
    def index
      @hits = Catalogillo::Product.search do
        all_of do
          with(:id).greater_than(0)
        end
      end.hits
    end
  end
end