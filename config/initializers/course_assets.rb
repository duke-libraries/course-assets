require 'devise_remote_user'

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
end
