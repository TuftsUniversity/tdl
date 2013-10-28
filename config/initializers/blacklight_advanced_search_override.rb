BlacklightAdvancedSearch::RenderConstraintsOverride.module_eval do


#Over-ride of Blacklight method, provide advanced constraints if needed,
# otherwise call super. Existence of an @advanced_query instance variable
# is our trigger that we're in advanced mode.
  def render_constraints_query(my_params = params)
    if (@advanced_query.nil?)
      return super(my_params)
    end

    # Add year_start and year_end params back so that nav-pills for them appear properly.
    rack_req = request.env['rack.request.query_hash']
    unless rack_req['year_start'].nil? || rack_req['year_start'].empty?
      @advanced_query.keyword_queries['year_start'] = rack_req['year_start']
    end
    unless rack_req['year_end'].nil? || rack_req['year_end'].empty?
      @advanced_query.keyword_queries['year_end'] = rack_req['year_end']
    end

    if (@advanced_query.keyword_queries.empty?)
      return super(my_params)
    end

    content = ""
    @advanced_query.keyword_queries.each_pair do |field, query|
      label = search_fields_for_advanced_search[field]['label']
      content << render_constraint_element(
          label, query,
          :remove =>
              catalog_index_path(remove_advanced_keyword_query(field, my_params))
      )
    end
    if (@advanced_query.keyword_op == "OR" &&
        @advanced_query.keyword_queries.length > 1)
      content = '<span class="inclusive_or appliedFilter">' + '<span class="operator">Any of:</span>' + content + '</span>'
    end

    return content
  end
end
