module CourseAssets
  module FilesControllerBehavior
    
    # Overriding Sufia::FilesControllerBehavior to disable terms of service acceptance check
    def terms_accepted?
      true
    end

  end
end