Catalogillo::Engine.routes.draw do

  #api_version(:module => "api", :path => {:value => "api/v1/catalog"}) do
  #  match '/update' => 'v1/catalogs#update', :via => :post
  #end

  match "/api/v1/catalog/index" => 'api/v1/catalogs#index', via: :post

  match "/:slug" => 'catalogs#index'
end
