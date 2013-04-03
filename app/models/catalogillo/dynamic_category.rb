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

    def sort_by param = ""
      sorting_option = available_sorting_options.has_key?(param) ? param : default_sorting
      field, by = sorting_option.split(',')
      [field, (by || "asc").to_sym]
    end

    def available_sorting_options
      @available_sorting_options ||= ActiveSupport::JSON.decode(sorting_options)
    end

    def default_sorting
      @default_sorting ||= available_sorting_options.select {|element, value| value["default"] == true }.keys.first
    end
  end
end

