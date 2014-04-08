require 'spec_helper'

module CourseAssets::Jobs

describe ContentDepositorChangeEventJob do
  before do
    @depositor = FactoryGirl.create(:user)
    @receiver = FactoryGirl.create(:user)
    @file = GenericFile.new.tap do |gf|
      gf.apply_depositor_metadata(@depositor.user_key)
      gf.save!
    end
    CourseAssets::Jobs::ContentDepositorChangeEventJob.new(@file.pid, @receiver.user_key).run
  end
  after do
    @file.delete
    @depositor.delete
    @receiver.delete
  end
  it "should change the depositor to the new user, and record the original depositor as the proxy" do
      @file.reload
      @file.depositor.should == @receiver.user_key
      @file.proxy_depositor.should == @depositor.user_key
      @file.edit_users.should include(@receiver.user_key, @depositor.user_key)
  end
end

end