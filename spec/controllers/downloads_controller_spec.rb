require 'spec_helper'

describe DownloadsController do
  let(:user) { FactoryGirl.create(:user) }
  let(:file) { GenericFile.new(title: "Test Download", creator: "Mick Jagger") }
  let(:upload) { fixture_file_upload("star-blue-full.png", "image/png") }
  before do
    @routes = Sufia::Engine.routes
    file.apply_depositor_metadata user
    allow(file).to receive(:characterize_if_changed).and_yield
    allow(CourseAssets).to receive(:external_datastore_base) { Dir.tmpdir }
    file.add_file(upload, "content", upload.original_filename)
    file.save!
    sign_in user
  end
  it "should send the file as an attachment" do
    get :show, id: file
    expect(response.headers["Content-Disposition"]).to eq("attachment; filename=\"star-blue-full.png\"")
  end
end
