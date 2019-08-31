require './config/environment'
require './app/auth'
require './app/yangbot'
require './app/api'

# Initialize the app and create the API (bot) and Auth objects.
run Rack::Cascade.new [API, Auth]
