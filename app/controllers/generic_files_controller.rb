class GenericFilesController < ApplicationController
  include Sufia::Controller
  include Sufia::FilesControllerBehavior
  include CourseAssets::FilesControllerBehavior
end