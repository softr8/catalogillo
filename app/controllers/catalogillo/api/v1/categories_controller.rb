module Catalogillo
  module Api
    module V1
      class CategoriesController < ApplicationController

        def index
          params[:categories].each do |category|
            Category.new(category).index
          end
          head Sunspot.commit ? :ok : :unprocessable_entity
        end

        def destroy
          head Sunspot.remove(Catalogillo::Category) { with(:id, params[:id])} ? :ok : :unprocessable_entity
        end
      end
    end
  end
end
