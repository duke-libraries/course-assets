class DownloadsController < ApplicationController

  include Sufia::DownloadsControllerBehavior

  def show
    if datastream.external?
      send_file datastream.filename, content_options.merge(disposition: 'attachment')
    else
      super
    end
  end

end
