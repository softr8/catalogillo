module Catalogillo
  class CategoriesController < ApplicationController
    before_filter :pagination_variables

    def index
      @category = Catalogillo::DynamicCategory.filter(filters: {slug: {starting_with: params[:slug]}}).first
      raise Catalogillo::RecordNotFound.new("Dynamic Category not found using slug: #{params[:slug]}") if @category.nil?
      @sort_by = @category.sort_by(params[:sort_by])

      unless Rails.cache.exist?("views/content-category-#{@category.id}-#{@current_page}-#{@per_page}-#{@sort_by.join}-#{@category.version}")
        options = {sort_by: @sort_by, page: @current_page, per_page: @per_page}
        @hits = Catalogillo::Product.filter(options.merge(filters: @category.query))
      end
    end

    def search
      @category = Catalogillo::Config.search_category
      @sort_by = @category.sort_by(params[:sort_by])

      @category.version = Digest::MD5.hexdigest(params[:keyword] || 'null')
      unless Rails.cache.exist?("views/content-category-#{@category.id}-#{@current_page}-#{@per_page}-#{@sort_by.join}-#{@category.version}")
        options = {sort_by: @sort_by, page: @current_page, per_page: @per_page}
        @hits = Catalogillo::Product.filter(options.merge(filters: {keywords: params[:keyword] || 'null'}.merge(@category.query)))
      end
      render :index
    end

    private
    def pagination_variables
      @current_page = params[:page] || Catalogillo::Config.page
      @per_page = params[:per_page] || Catalogillo::Config.per_page
    end
  end
end