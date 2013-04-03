module Catalogillo
  class ApplicationController < ActionController::Base

    rescue_from Catalogillo::RecordNotFound do |exception|
      render partial: 'common/not_found', status: 404
    end

    rescue_from Catalogillo::ModelBase::Error do |exception|
      render json: {errors: exception.message, usage: Product.usage}, status: :unprocessable_entity
    end
  end
end
