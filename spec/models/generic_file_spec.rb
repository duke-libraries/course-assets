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

  context "content" do
    let(:file) { FactoryGirl.create(:generic_file) }
    before do
      allow(file).to receive(:characterize_if_changed).and_yield
      allow(CourseAssets).to receive(:external_datastore_base) { Dir.tmpdir }
    end
    context "upload" do
      let(:upload) { fixture_file_upload("star-blue-full.png", "image/png") }
      let(:file_path) { "#{Dir.tmpdir}/3/9/dd/39dd01e3-5eb9-43bc-ba2f-8a0518f1d033/star-blue-full.png" }
      let(:file_uri) { URI.escape("file://#{file_path}") }
      before do
        allow(file).to receive(:external_file_dirbase) { "39dd01e3-5eb9-43bc-ba2f-8a0518f1d033" }
        file.add_file(upload, "content", upload.original_filename)
        file.save!
      end
      it "should store the content externally" do
        expect(File.exists?(file_path)).to be_true
        expect(File.size(file_path)).to eq(upload.size)
        expect(file.content.controlGroup).to eq("E")
        expect(file.content.versionable).to be_true
        expect(file.content.mimeType).to eq("image/png")
        expect(file.content.dsLocation).to eq(file_uri)
        expect(file.content.filename).to eq(URI.unescape(file_uri).sub('file://', ''))
        expect(file.label).to eq("star-blue-full.png")
        expect(file.title.first).to eq("star-blue-full.png")
      end
    end
    context "delete" do
      before do
        allow(file).to receive(:external_file_dirbase).and_return("7ef80c48-a406-4dc8-961c-2fdc451f62ec", "9a4cf75d-612f-4f46-a0af-b4d110af4efe")
        file.add_file(File.new("#{Rails.root}/spec/fixtures/star-blue-full.png"), "content", "star-blue-full.png")
        file.save!
        file.add_file(File.new("#{Rails.root}/spec/fixtures/star-blue-full.png"), "content", "star-blue-full.png")
        file.save!
      end
      it "should delete all external content file versions" do
        file_paths = file.content.versions.each.map { |v| URI::parse(v.dsLocation).path }
        file.destroy
        file_paths.each { |fp| expect(File.exists?(fp)).to be_false }
      end
    end
  end
end
