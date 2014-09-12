require 'spec_helper'

describe GenericFilesController, proxy: true do
  
  context "#create" do
    let(:user) { FactoryGirl.create(:user) }
    let(:batch_noid) { Sufia::Noid.noidify(Sufia::IdService.mint) }
    context "proxy deposit" do
      let(:proxied_user) { FactoryGirl.create(:user) }
      before do
        @routes = Sufia::Engine.routes
        user.can_make_deposits_for << proxied_user
        user.save!
        sign_in user
      end
      context "My Computer upload" do
        it "should set the 'on_behalf_of' attribute of the GenericFile"
      end
      context "Local file ingest" do
        let(:local_ingest_base) { Dir.mktmpdir("course_assets_test") }
        before do
          FileUtils.cp File.join(Rails.root, 'spec', 'fixtures', 'star-blue-full.png'), local_ingest_base
          User.any_instance.stub(:directory).and_return(local_ingest_base)
          post :create, local_file: [ 'star-blue-full.png' ], on_behalf_of: proxied_user.user_key, batch_id: batch_noid
          @generic_file = GenericFile.first
        end
        after { FileUtils.remove_dir local_ingest_base }
        it "should set the 'on_behalf_of' attribute of the GenericFile" do
          expect(@generic_file.on_behalf_of).to eql(proxied_user.user_key)
        end        
      end
    end
  end
  
end