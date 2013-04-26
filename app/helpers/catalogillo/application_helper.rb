module Catalogillo
  module ApplicationHelper

    def page_entries_info(collection, options = {})
      entry_name = options[:entry_name] || (collection.empty? ? 'entry' :
          collection.first.class.name.underscore.gsub('_', ' '))

      plural_name = if options[:plural_name]
                      options[:plural_name]
                    elsif entry_name == 'entry'
                      plural_name = 'entries'
                    elsif entry_name.respond_to? :pluralize
                      plural_name = entry_name.pluralize
                    else
                      entry_name + 's'
                    end

      unless options[:html] == false
        sp = '&nbsp;'
      else
        sp = ' '
      end

      content_tag :span, class: 'page-entries-info' do
        if collection.total_pages < 2
          case collection.size
            when 0;
              "No #{plural_name} found"
            when 1;
              "Showing 1 #{entry_name}"
            else
              ; "Showing all #{collection.size} #{plural_name}"
          end
        else
          %{Showing #{plural_name} %s#{sp}-#{sp}%s of %s} % [
              number_with_delimiter(collection.offset + 1),
              number_with_delimiter(collection.offset + collection.length),
              number_with_delimiter(collection.total_entries)
          ]
        end.html_safe
      end
    end

    def available_sorting_options options = {}
      (options || {}).inject({}){|final, element| final[element.second["title"]] = element.first ; final}
    end

  end
end
