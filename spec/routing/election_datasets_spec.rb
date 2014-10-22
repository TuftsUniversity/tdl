require 'spec_helper'

describe 'Election datasets routing: ' do

  it 'route to index page' do

    expect(get: 'election_datasets').to route_to(
                                            controller: 'catalog',
                                            action: 'index',
                                            f: {"object_type_sim" => ['Generic Objects'], "names_sim" => ['American Antiquarian Society']},
                                            q: '',
                                            search_field: 'all_fields')
  end

end
