module Catalogillo
  class DynamicCategory < ModelBase
    class << self
      def metadata
        {
            fields: [
                {name: "id", type: "Integer", required: true, description: "Dynamic Category unique identifier"},
                {name: "name", type: "String", required: true, description: "Dynamic Category name"},
                {name: "slug", type: "String", required: true, description: "Dynamic Category slug's name"},
                {name: "search_query", type: "String", required: true, description: "Search Query"},
                {name: "sorting_options", type: "String", required: true, description: "Sorting options to display"},
                {name: "version", type: "Integer", required: true, description: "Current Dynamic Category Version, expires cache when changed"},
            ]
        }
      end
    end

    make_it_searchable

    def query
      @query ||= ActiveSupport::JSON.decode(search_query)
    end

  end
end

