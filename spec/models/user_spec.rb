require 'spec_helper'

describe User do
  
  after { User.destroy_all }

  context "audituser" do
    let(:audituser_key) { "test_audituser" }
    let(:audituser_email) { "test_audituser@example.com" }
    before do
      CourseAssets.audituser_key = audituser_key
      CourseAssets.audituser_email = audituser_email
    end
    it "should find (or create) the audituser" do
      expect(User.audituser.user_key).to eql(audituser_key)
      expect(User.audituser.email).to eql(audituser_email)
    end    
  end
  
  context "batchuser" do
    let(:batchuser_key) { "test_batchuser" }
    let(:batchuser_email) { "test_batchuser@example.com" }
    before do
      CourseAssets.batchuser_key = batchuser_key
      CourseAssets.batchuser_email = batchuser_email
    end
    it "should find (or create) the batchuser" do
      expect(User.batchuser.user_key).to eql(batchuser_key)
      expect(User.batchuser.email).to eql(batchuser_email)
    end    
  end

end