module Catalogillo
  class ProductsController < ApplicationController

    def show
      p = Catalogillo::Product.find(params[:id])
      render json: p
    end
  end
end