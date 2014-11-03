require 'spec_helper'

describe "catalog/_index_partials/_list_files.html.erb", type: :view do
  let(:file) { FactoryGirl.create(:generic_file) }
  it "should render the partial" do
    document = SolrDocument.new(file.to_solr)
    render partial: "catalog/_index_partials/list_files.html.erb", locals: {document: document}
    expect(rendered).to match(/Test File/)
  end
end
