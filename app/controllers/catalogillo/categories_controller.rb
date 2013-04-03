module Catalogillo
  class CategoriesController < ApplicationController
    def index
      @category = Catalogillo::DynamicCategory.filter(filters: {slug: {starting_with: params[:slug]}}).first
      raise Catalogillo::RecordNotFound.new("Dynamic Category not found using slug: #{params[:slug]}") if @category.nil?
      @sort_by = @category.sort_by(params[:sort_by])
      @current_page = params[:page] || Catalogillo::Config.page
      @per_page = params[:per_page] || Catalogillo::Config.per_page
      unless Rails.cache.exist?("views/content-category-#{@category.id}-#{@current_page}-#{@per_page}-#{@sort_by.join}-#{@category.version}")
        options = {sort_by: @sort_by}
        options.merge!(page: params[:page]) if params[:page]
        options.merge!(per_page: params[:per_page]) if params[:per_page]
        @hits = Catalogillo::Product.filter(options.merge(filters: @category.query))
      end
    end

    def search
      @hits = Catalogillo::Product.filter(filters: {keywords: params[:keyword]})
    end

  end
end