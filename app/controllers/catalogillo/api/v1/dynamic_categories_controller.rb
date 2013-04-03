module Catalogillo
  module Api
    module V1
      class DynamicCategoriesController < ApplicationController

        def index
          search_query = params[:dynamic_category].delete(:search_query)
          Sunspot.index DynamicCategory.new params[:dynamic_category].merge(search_query: ActiveSupport::JSON.encode(search_query))
          head Sunspot.commit ? :ok : :unprocessable_entity
        end

      end
    end
  end
end
