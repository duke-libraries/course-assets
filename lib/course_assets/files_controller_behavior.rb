module CourseAssets
  module FilesControllerBehavior
    
    # Overriding Sufia::FilesControllerBehavior to save on_behalf_of
    def update_metadata_from_upload_screen
      super
      @generic_file.on_behalf_of = params[:on_behalf_of] if params[:on_behalf_of]
    end

    # Overriding Sufia::FilesController::LocalIngestBehavior to save on_behalf_of
    def ingest_one(filename, unarranged)
        # do not remove :: 
        @generic_file = ::GenericFile.new
        basename = File.basename(filename)
        @generic_file.label = basename
        @generic_file.relative_path = filename if filename != basename
        @generic_file.on_behalf_of = params[:on_behalf_of] if params[:on_behalf_of]
        create_metadata(@generic_file)
        Sufia.queue.push(IngestLocalFileJob.new(@generic_file.id, current_user.directory, filename, current_user.user_key))
    end
    
    # Overriding Sufia::FilesControllerBehavior to disable terms of service acceptance check
    def terms_accepted?
      true
    end

  end
end