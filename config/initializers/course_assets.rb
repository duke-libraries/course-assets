require 'course_assets'
require 'devise_remote_user'

CourseAssets.configure do |config|
  config.audituser_key = Rails.env.test? ? "audituser" : ENV['AUDITUSER_KEY']
  config.audituser_email = Rails.env.test? ? "audituser@nowhere.com" : ENV['AUDITUSER_EMAIL']
  config.batchuser_key = Rails.env.test? ? "batchuser" : ENV['BATCHUSER_KEY'] 
  config.batchuser_email = Rails.env.test? ? "batchuser@nowhere.com" : ENV['BATCHUSER_EMAIL']
  config.external_datastore_base = ENV['EXTERNAL_DATASTORE_BASE']
  config.local_ingest_base = ENV['LOCAL_INGEST_BASE']
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
    last_name: 'sn',
    department: 'ou'
  }
  config.logout_url = "/Shibboleth.sso/Logout?return=https://shib.oit.duke.edu/cgi-bin/logout.pl"
end
