require 'course_assets'
require 'devise_remote_user'

CourseAssets.configure do |config|
  config.audituser_key = ENV['AUDITUSER_KEY']
  config.audituser_email = ENV['AUDITUSER_EMAIL']
  config.batchuser_key = ENV['BATCHUSER_KEY']
  config.batchuser_email = ENV['BATCHUSER_EMAIL']
  config.directory_conf = {
    host: ENV['DIRECTORY_HOST'],
    base: ENV['DIRECTORY_BASE']
  }
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
