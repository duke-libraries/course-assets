require 'spec_helper'

describe GenericFile do
  
  context "collectible" do
    it "should be collectible" do
      expect(subject).to be_a(Hydra::Collections::Collectible)
    end
  end
  
  context "proxy deposit" do
    let(:user_a) { FactoryGirl.create(:user) }
    let(:user_b) { FactoryGirl.create(:user) }
    let(:file) { GenericFile.new }
    let(:stub_job) { double('change depositor job') }
    before do
      file.apply_depositor_metadata(user_a.user_key)
      file.on_behalf_of = user_b.user_key
    end
    # after do
    #   file.destroy
    #   user_a.destroy
    #   user_b.destroy
    # end
    it "should transfer the file" do
      CourseAssets::Jobs::ContentDepositorChangeEventJob.should_receive(:new).and_return(stub_job)
      Sufia.queue.should_receive(:push).with(stub_job).once.and_return(true)
      file.save!
    end
  end

  context "metadata" do
    let(:file) { FactoryGirl.create(:generic_file) }
    it "should be assignable to one or more courses" do
      file.course = "PSYCH 101"
      file.save
      expect(GenericFile.find(course: "PSYCH 101")).to eq([file])
    end
  end
  
end
