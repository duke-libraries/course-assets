# Returns an array containing the vhost 'CoSign service' value and URL
Sufia.config do |config|

  config.fits_to_desc_mapping= {
    :file_title => :title,
    :file_author => :creator
  }

  # Specify a different template for your repositories unique identifiers
  # config.noid_template = ".reeddeeddk"

  config.max_days_between_audits = 7

  config.cc_licenses = {
    'Attribution 3.0 United States' => 'http://creativecommons.org/licenses/by/3.0/us/',
    'Attribution-ShareAlike 3.0 United States' => 'http://creativecommons.org/licenses/by-sa/3.0/us/',
    'Attribution-NonCommercial 3.0 United States' => 'http://creativecommons.org/licenses/by-nc/3.0/us/',
    'Attribution-NoDerivs 3.0 United States' => 'http://creativecommons.org/licenses/by-nd/3.0/us/',
    'Attribution-NonCommercial-NoDerivs 3.0 United States' => 'http://creativecommons.org/licenses/by-nc-nd/3.0/us/',
    'Attribution-NonCommercial-ShareAlike 3.0 United States' => 'http://creativecommons.org/licenses/by-nc-sa/3.0/us/',
    'Public Domain Mark 1.0' => 'http://creativecommons.org/publicdomain/mark/1.0/',
    'CC0 1.0 Universal' => 'http://creativecommons.org/publicdomain/zero/1.0/',
    'All rights reserved' => 'All rights reserved'
  }

  config.cc_licenses_reverse = Hash[*config.cc_licenses.to_a.flatten.reverse]

  config.resource_types = {
    "Audio" => "Audio",
    "Image" => "Image",
    "Presentation" => "Presentation",
    "Reading" => "Reading",
    "Screencast (ScreenFlow)" => "Screencast (ScreenFlow)",
    "Video" => "Video",
    "Other" => "Other",
  }

  config.permission_levels = {
    "Choose Access"=>"none",
    "View/Download" => "read",
    "Edit" => "edit"
  }

  config.owner_permission_levels = {
    "Edit" => "edit"
  }

  config.queue = Sufia::Resque::Queue

  # Map hostnames onto Google Analytics tracking IDs
  # config.google_analytics_id = 'UA-99999999-1'


  # Where to store tempfiles, leave blank for the system temp directory (e.g. /tmp)
  # config.temp_file_base = '/home/developer1'

  # If you have ffmpeg installed and want to transcode audio and video uncomment this line
  config.enable_ffmpeg = true

  # Specify the Fedora pid prefix:
  # config.id_namespace = "sufia"

  # Specify the path to the file characterization tool:
  # config.fits_path = "fits.sh"

  # contact form email addresses
  config.contact_email = ENV['SUFIA_CONTACT_EMAIL']
  config.from_email = ENV['SUFIA_FROM_EMAIL']

  config.enable_local_ingest = true
end

Date::DATE_FORMATS[:standard] = "%m/%d/%Y"
