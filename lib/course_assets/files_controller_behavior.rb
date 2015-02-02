module CourseAssets
  module FilesControllerBehavior
    
    # Overriding Sufia::FilesController::LocalIngestBehavior to save on_behalf_of
    def ingest_one(filename, unarranged)
      basename = File.basename(filename)
      # do not remove :: 
      generic_file = ::GenericFile.new(label: basename).tap do |gf|
        gf.relative_path = filename if filename != basename
        gf.on_behalf_of = params[:on_behalf_of] if params[:on_behalf_of]
        actor = Sufia::GenericFile::Actor.new(gf, current_user)
        actor.create_metadata(params[:batch_id])
        gf.save!
        Sufia.queue.push(IngestLocalFileJob.new(gf.id, current_user.directory, filename, current_user.user_key))
      end
    end

    # Overriding Sufia::FilesControllerBehavior to disable terms of service acceptance check
    def terms_accepted?
      true
    end

  end
end