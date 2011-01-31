class BasicFilter

  def filter(query_string, relation)
    method_name = query_string.gsub(' ', '_').underscore
    self.send(method_name, relation)
  end

  def table_name(relation)
    relation.klass.name.tableize
  end

end