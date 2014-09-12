require 'spec_helper'

describe 'batch/edit.html.erb' do
  let(:user) { FactoryGirl.create(:user) }
  before do
    @routes = Sufia::Engine.routes
    login_as user
  end
  after { Warden.test_reset! }
  context "Terms of Service checkbox" do
    it "should be checked" do
      pending("figuring out why this test fails in Travis")
      visit "/files/new"
      within(:css, 'form#fileupload') do
        expect(find('#terms_of_service')).to be_checked      
      end
      within(:css, 'form#new_generic_file') do
        expect(find('#terms_of_service')).to be_checked      
      end
    end
  end
end