# properties datastream: catch-all for info that didn't have another home.  Particularly depositor.
class PropertiesDatastream < ActiveFedora::OmDatastream
  include Sufia::PropertiesDatastreamBehavior
  include CourseAssets::PropertiesDatastreamBehavior
end
