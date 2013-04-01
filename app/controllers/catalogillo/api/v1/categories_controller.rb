module Catalogillo
  module Api
    module V1
      class CategoriesController < ApplicationController

        def index
          params[:categories].each do |category|
            Sunspot.index Category.new category
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
