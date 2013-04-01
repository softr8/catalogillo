module Catalogillo
  module Api
    module V1
      class DynamicCategoriesController < ApplicationController

        def index
          puts params.inspect
          Sunspot.index DynamicCategory.new params[:dynamic_category]
          head Sunspot.commit ? :ok : :unprocessable_entity
        end

      end
    end
  end
end
