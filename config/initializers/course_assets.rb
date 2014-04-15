require 'course_assets'
require 'devise_remote_user'
require 'directory_service'

CourseAssets.configure do |config|
  config.audituser_key = ENV['AUDITUSER_KEY']
  config.audituser_email = ENV['AUDITUSER_EMAIL']
  config.batchuser_key = ENV['BATCHUSER_KEY']
  config.batchuser_email = ENV['BATCHUSER_EMAIL']
end

DirectoryService.configure do |config|
  config.host = ENV['DIRECTORY_HOST']
  config.base = ENV['DIRECTORY_BASE']
  config.attributes = ENV['DIRECTORY_ATTRIBUTES'].split
end

DeviseRemoteUser.configure do |config|
  # config.env_key = 'REMOTE_USER'
  config.auto_create = true
  config.auto_update = true
  config.attribute_map = {
    email: 'mail',
    display_name: 'displayName',
    first_name: 'givenName',
    middle_name: 'duMiddleName1',
    nickname: 'eduPersonNickname',
    last_name: 'sn'
  }
  config.logout_url = "/Shibboleth.sso/Logout?return=https://shib.oit.duke.edu/cgi-bin/logout.pl"
end
