source 'http://rubygems.org'

gem 'rails', '3.0.7'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

#gem 'sqlite3-ruby', :require => 'sqlite3'
gem 'mysql2', '< 0.3'
gem 'builder'

gem 'restful_jsonp', '~> 1.0.2'

# Load Ejabberd integration code
#gem 'rollcall-ejabberd', :git => 'git://github.com/educoder/rollcall-ejabberd.git'

# Load Prosody integration code
#gem 'rollcall-prosody', :git => 'git://github.com/educoder/rollcall-prosody.git'

# Load OpenFire integration code
# gem 'rollcall-openfire', :git => 'git://github.com/educoder/rollcall-openfire.git'

gem 'rollcall-prosody', :path => '../rollcall-prosody' #:git => 'git://github.com/educoder/rollcall-prosody.git'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

group :test, :development do
  #gem 'rspec-rails', '~> 2.0.0.beta.20'
  gem 'rspec-rails', ">= 2.0.0.beta.22"
  gem 'rest-client'
  gem 'nokogiri'
  gem 'json'
  gem 'ruby-debug'
end

# Bundle the extra gems:
# gem 'bj'
# gem 'nokogiri', '1.4.1'
# gem 'sqlite3-ruby', :require => 'sqlite3'
# gem 'aws-s3', :require => 'aws/s3'

# Bundle gems for certain environments:
# gem 'rspec', :group => :test
# group :test do
#   gem 'webrat'
# end
