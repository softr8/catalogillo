module Catalogillo
  class Category < ModelBase

    class << self
      def metadata
        {
            fields: [
                {name: "id", type: "Integer", required: true, description: "Category unique identifier"},
                {name: "name", type: "String", required: true, description: "Category name"},
                {name: "ancestry_id", type: "Integer", required: true, description: "Parent's category"},
                {name: "slug", type: "String", required: true, description: "Category slug's name"},
                {name: "version", type: "integer", required: true, description: "Current Category Version, expires cache when changed"},
            ]
        }
      end

      def filter params
        Catalogillo::ModelBase::Collection.new(search do
          with(:id, params[:id]) if params.has_key?(:id)
          with(:name, params[:name]) if params.has_key?(:name)
        end)
      end
    end

    make_it_searchable

  end
end
