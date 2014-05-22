require 'spec_helper'

describe 'batch/edit.html.erb', proxy: true do
  let(:user) { FactoryGirl.create(:user, first_name: "First", middle_name: "Middle", last_name: "Last") }
  let(:batch) { Batch.create }
  let(:generic_file) do
    GenericFile.new.tap do |gf|
      gf.depositor = user.user_key
      gf.batch = batch
      gf.apply_depositor_metadata user
      gf.save!
    end
  end
  before do
    @routes = Sufia::Engine.routes
    login_as user
  end
  after { Warden.test_reset! }
  context "pre-populate creator" do
    before { generic_file.reload }
    it "should pre-populate the creator field with one entry" do
      visit "/batches/#{batch.id}/edit"
      expect(page).to have_field("Creator", with: "Last, First Middle")
    end
  end
end