module Catalogillo
  module Api
    module V1
      class CatalogsController < ApplicationController

        rescue_from Catalogillo::ModelBase::Error do |exception|
          render json: {errors: exception.message, usage: Product.usage}, status: :unprocessable_entity
        end

        def index
          params[:products].each do |p|
            Sunspot.index Product.new p
          end
          head Sunspot.commit ? :ok : :unprocessable_entity
        end

      end
    end
  end
end