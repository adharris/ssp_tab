# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
SspCtab::Application.initialize!

#Setup the host domain
config.action_mailer.default_url_options = { :host => 'ssp-food.heroku.com' }
