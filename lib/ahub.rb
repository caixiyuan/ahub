require "ahub/version"
require "ahub/user"
require "ahub/question"
require "ahub/answer"
require 'csv'
require 'dotenv'

module Ahub
  #Load the .env file from the default location...
  Dotenv.load

  #or a location passed in.
  Dotenv.load ENV['AHUB_ENV_FILE'] if ENV['AHUB_ENV_FILE']

  DOMAIN = ENV['AHUB_DOMIAN'] || 'http://localhost:8888'
  DEFAULT_PASSWORD = ENV['AHUB_DEFAULT_PASSWORD'] || 'password'
  ADMIN_USER = ENV['AHUB_ADMIN_USER'] || 'answerhub'
  ADMIN_PASS = ENV['AHUB_ADMIN_PASS'] || 'answerhub'

  def self.fire
    "Nailed it!"
  end
end
