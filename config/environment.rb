require 'dotenv/load'
require 'redis'

$redis = Redis.new(url: ENV["REDIS_URI"])
