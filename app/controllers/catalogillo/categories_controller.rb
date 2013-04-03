module Catalogillo
  class CategoriesController < ApplicationController
    def index
      @category = Catalogillo::DynamicCategory.filter(filters: {slug: {starting_with: params[:slug]}}).first
      raise Catalogillo::RecordNotFound.new("Dynamic Category not found using slug: #{params[:slug]}") if @category.nil?
      pagination = {}
      pagination.merge!(page: params[:page]) if params[:page]
      pagination.merge!(per_page: params[:per_page]) if params[:per_page]
      @hits = Catalogillo::Product.filter(pagination.merge(filters: @category.query))
    end

    def search
      @hits = Catalogillo::Product.filter(filters: {keywords: params[:keyword]})
    end
  end
end