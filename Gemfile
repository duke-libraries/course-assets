source 'http://rubygems.org'

gem 'rails', '4.0.3'

# Sufia
gem 'sufia', '4.3.1'
gem 'blacklight-marc'
# required to handle pagination properly in dashboard. See https://github.com/amatsuda/kaminari/pull/322
gem 'kaminari', github: 'harai/kaminari', branch: 'route_prefix_prototype'
gem 'font-awesome-sass-rails'
gem 'select2-rails', '3.4.2'

# Duke directory integration
gem 'directory-service', github: 'duke-libraries/directory-service', tag: 'v0.3.0'

# Questioning Authority
gem 'qa', '~> 0.3.0'

# Use sqlite3 as the database for Active Record
gem 'sqlite3'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

group :development, :test do
  gem 'rspec-rails'
  gem 'jettywrapper'
  gem 'capybara', '~> 2.0'
  gem 'factory_girl_rails', '~> 4.0'
end

group :production do
  gem 'mysql2'
end

gem "bootstrap-sass"

gem "devise"
gem "devise-guests", "~> 0.3"
gem "devise-remote-user", '0.3.0'

gem 'hydra-collections'