module Catalogillo
  module Api
    module V1
      class ProductsController < ApplicationController

        def index
          params[:products].each do |p|
            product = Catalogillo::Product.new p
            product.index
          end
          head Sunspot.commit ? :ok : :unprocessable_entity
        end

        def destroy
          head Sunspot.remove(Catalogillo::Product) { with(:id, params[:id])} ? :ok : :unprocessable_entity
        end
      end
    end
  end
end