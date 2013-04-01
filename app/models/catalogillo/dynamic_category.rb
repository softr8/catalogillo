module Catalogillo
  class DynamicCategory < ModelBase
    class << self
      def metadata
        {
            fields: [
                {name: "id", type: "Integer", required: true, desctiption: "Dynamic Category unique identifier"},
                {name: "name", type: "String", required: true, desctiption: "Dynamic Category name"},
                {name: "slug", type: "String", required: true, desctiption: "Dynamic Category slug's name"},
                {name: "search_query", type: "String", required: true, desctiption: "Search Query"},
                {name: "version", type: "Integer", required: true, desctiption: "Current Dynamic Category Version, expires cache when changed"},
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

