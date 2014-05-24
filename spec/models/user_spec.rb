require 'spec_helper'

describe User do
  
  after { User.destroy_all }

  context "attributes" do
    context "#inverted_name" do
      let(:user) { FactoryGirl.build(:user) }
      before do
        user.first_name = "John"
        user.middle_name = "Quincy"
        user.last_name = "Smith"
      end
      it "should return an inverted form of the user's name" do
        expect(user.inverted_name).to eql("Smith, John Quincy")
      end
    end
  end

  context "audituser" do
    let(:audituser_key) { "test_audituser" }
    let(:audituser_email) { "test_audituser@example.com" }
    before do
      allow(CourseAssets).to receive(:audituser_key) { audituser_key }
      allow(CourseAssets).to receive(:audituser_email) { audituser_email }
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
      allow(CourseAssets).to receive(:batchuser_key) { batchuser_key }
      allow(CourseAssets).to receive(:batchuser_email) { batchuser_email }
    end
    it "should find (or create) the batchuser" do
      expect(User.batchuser.user_key).to eql(batchuser_key)
      expect(User.batchuser.email).to eql(batchuser_email)
    end    
  end
  
  context "local ingest" do
    let(:user) { FactoryGirl.create(:user) }
    let(:netid) { user.user_key.split("@").first }
    let(:test_dir) { Dir.mktmpdir("course_assets_test") }
    let(:user_dir) { File.join(test_dir, netid) }
    let(:user_videos_dir) { File.join(user_dir, "videos") }
    let(:top_files) { [ "file1.jpg", "file2.jpg" ] }
    let(:video_files) { [ "a.mov", "b.mov", "c.mov"] }
    let(:expected) do
      [ { name: "file1.jpg", directory: false },
        { name: "file2.jpg", directory: false },
        { name: "videos/a.mov", directory: false },
        { name: "videos/b.mov", directory: false }, 
        { name: "videos/c.mov", directory: false } 
      ]
    end
    before do
      CourseAssets.stub(:local_ingest_base).and_return(test_dir)
      FileUtils.mkdir_p(user_dir)
      FileUtils.mkdir_p(user_videos_dir)
      top_files.each { |f| FileUtils.touch(File.join(user_dir, f)) }
      video_files.each { |f| FileUtils.touch(File.join(user_videos_dir, f)) }
    end
    after { FileUtils.remove_dir test_dir }
    it "should list the user's uploadable local files" do
      expect(user.files.size).to eql(5)
      expect(user.files).to match_array(expected)
    end
  end

  describe ".create_by_netid" do
    subject { described_class.create_by_netid("foobar") }
    let(:ds_result) { double("directory service result") }
    context "when user exists in local db" do
      let(:user) { double("user") }
      it "should return false" do
        allow(described_class).to receive(:find_by_username).with("foobar@duke.edu") { user }
        expect(subject).to be_false
      end
    end
    context "when the directory lookup fails" do
      it "should return false" do
        allow(DirectoryService.any_instance).to receive(:find_by_edupersonprincipalname).with("foobar@duke.edu") { nil }
        expect(subject).to be_false
      end
    end
    context "when unable to persist new user" do
      it "should return false" do
        allow(User.any_instance).to receive(:persisted?) { false }
        allow(User.any_instance).to receive(:update_directory_attributes).with(ds_result) { nil }
        allow(DirectoryService.any_instance).to receive(:find_by_edupersonprincipalname).with("foobar@duke.edu") { ds_result }
        expect(subject).to be_false
      end
    end
    context "when successful" do
      xit "should return the created user" do
        allow(ds_result).to receive(:nil?) { false }
        allow(User.any_instance).to receive(:persisted?) { true }
        allow(User.any_instance).to receive(:update_directory_attributes).with(ds_result) { true }
        allow(DirectoryService.any_instance).to receive(:find_by_edupersonprincipalname).with("foobar@duke.edu") { ds_result }
        expect(subject).to be_a User
      end
    end
  end

  describe ".update_all_from_directory" do
    it "should update the directory attributes for all users in the database"
  end

  describe "#update_directory_attributes" do
    let(:user) { FactoryGirl.create(:user) }
    let(:ds_result) { double("directory result") }
    it "should update the user attributes from the directory result" do
      allow(CourseAssets).to receive(:user_attribute_map) { {email: "mail"} }
      allow(ds_result).to receive(:first_value).with("mail") { "foobar@duke.edu" }
      expect { user.update_directory_attributes(ds_result) }.to change { user.email }
    end
  end

end
