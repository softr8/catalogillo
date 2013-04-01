module Catalogillo
  class Category < ModelBase

    class << self
      def metadata
        {
            fields: [
                {name: "id", type: "Integer", required: true, desctiption: "Category unique identifier"},
                {name: "name", type: "String", required: true, desctiption: "Category name"},
                {name: "ancestry_id", type: "Integer", required: true, desctiption: "Parent's category"},
                {name: "slug", type: "String", required: true, desctiption: "Category slug's name"},
                {name: "version", type: "integer", required: true, desctiption: "Current Category Version, expires cache when changed"},
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
