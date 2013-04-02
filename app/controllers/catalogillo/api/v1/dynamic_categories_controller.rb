module Catalogillo
  module Api
    module V1
      class DynamicCategoriesController < ApplicationController

        def index
          Sunspot.index DynamicCategory.new params[:dynamic_category]
          head Sunspot.commit ? :ok : :unprocessable_entity
        end

      end
    end
  end
end
