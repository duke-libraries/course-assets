require 'spec_helper'

describe BatchController, proxy: true do

  let(:user) { FactoryGirl.create(:user, first_name: "First", middle_name: "Middle", last_name: "Last") }
  let(:batch) { Batch.create }
  let(:generic_file) do
    GenericFile.new.tap do |gf|
      gf.label = "Test Generic File"
      gf.depositor = user.user_key
      gf.batch = batch
      gf.apply_depositor_metadata user
      gf.save!
    end
  end

  before do
    @routes = Sufia::Engine.routes
    sign_in user
  end
  
  context "#edit" do
    context "no proxy" do
      before { generic_file.reload }
      it "should set the creator attribute to the depositor's inverted name" do
        get :edit, id: batch.id
        expect(assigns(:generic_file).creator).to match_array( [ "Last, First Middle" ] )
      end
    end
    context "proxy" do
      let(:proxied_user) { FactoryGirl.create(:user) }
      before do
        proxied_user.first_name = "ProxyFirst"
        proxied_user.middle_name = "ProxyMiddle"
        proxied_user.last_name = "ProxyLast"
        proxied_user.save!
        generic_file.on_behalf_of = proxied_user.user_key
        generic_file.save!
      end
      it "should set the creator attribute to the on_behalf_of's inverted name" do
        get :edit, id: batch.id
        expect(assigns(:generic_file).creator).to match_array( [ "ProxyLast, ProxyFirst ProxyMiddle" ] )
      end
    end
  end

end