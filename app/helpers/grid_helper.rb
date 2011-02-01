 module GridHelper

   def sortable_column_header(column_name, options = {})
     column_title = options[:title] || column_name.to_s.humanize
     html = %Q{<th class="sortable" data-column="#{column_name}">#{column_title}</th>}
     raw html
   end

   def non_sortable_column_header(title = "")
     html = %Q{<th>#{title}</th>}
     raw html
   end

 end