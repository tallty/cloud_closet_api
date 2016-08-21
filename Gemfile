#source 'https://rubygems.org'
source 'https://gems.ruby-china.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.0.0', '>= 5.0.0.1'
# Use sqlite3 as the database for Active Record
gem 'sqlite3'
# Use Puma as the app server
gem 'puma', '~> 3.0'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem 'rack-cors'

###############################################################################
# Automatically generate API documentation from RSpec, Read more: https://github.com/zipmark/rspec_api_documentation
gem 'rspec_api_documentation'


###############################################################################

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
  # rspec-rails is a testing framework for Rails 3.x, 4.x and 5.0. Read more: https://github.com/rspec/rspec-rails
  gem 'rspec-rails', '~> 3.5'
  # Collection of testing matchers extracted from Shoulda, Read more: https://github.com/thoughtbot/shoulda-matchers
  gem 'shoulda-matchers', '~> 3.1'
  # factory_girl is a fixtures replacement with a straightforward definition syntax, support for multiple build strategies 
  # (saved instances, unsaved instances, attribute hashes, and stubbed objects), and support for multiple factories for the same class 
  # (user, admin_user, and so on), including factory inheritance.
  # Read more: https://github.com/thoughtbot/factory_girl_rails
  gem 'factory_girl_rails'
end

group :development do
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
