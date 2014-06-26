require 'spec_helper'

describe 'batch/edit.html.erb', proxy: true do
  let(:user) { FactoryGirl.create(:user, first_name: "First", middle_name: "Middle", last_name: "Last") }
  let(:batch) { Batch.create }
  let(:generic_file) { GenericFile.create(depositor: user.user_key, batch: batch) }
  before do
    @routes = Sufia::Engine.routes
    login_as user
    generic_file.apply_depositor_metadata user
    generic_file.save!
  end
  after { Warden.test_reset! }
  context "pre-populate creator" do
    before { generic_file.reload }
    it "should pre-populate the creator field with one entry" do
      # pending("figuring out why this test fails in Travis")
      visit "/batches/#{batch.id}/edit"
      expect(page).to have_field("Creator", with: "Last, First Middle")
    end
  end
end