module Catalogillo
  class Category < ModelBase

    class << self
      def metadata
        {
            fields: [
                {name: "id", type: "Integer", required: true, description: "Category unique identifier"},
                {name: "name", type: "String", required: true, description: "Category name"},
                {name: "parent_id", type: "Integer", required: true, description: "Parent's category"},
                {name: "left_id", type: "Integer", required: true, description: "Nested set left id (http://mikehillyer.com/articles/managing-hierarchical-data-in-mysql/)"},
                {name: "right_id", type: "Integer", required: true, description: "Nested set right id (http://mikehillyer.com/articles/managing-hierarchical-data-in-mysql/)"},
                {name: "slug", type: "String", required: true, description: "Category slug's name"},
                {name: "version", type: "integer", required: true, description: "Current Category Version, expires cache when changed"},
                {name: "sorting_options", type: "String", required: false, description: "Sorting options to display"},
            ]
        }
      end
    end

    make_it_searchable

    def query
      ids = Collection.new(self.class.search do
        with(:left_id).greater_than(left_id)
        with(:right_id).less_than(right_id)
      end).map(&:id)

      { category_ids: {equal_to: [self.id] + ids} }
    end
  end
end
