require 'dotenv'
require 'rest_client'
require 'ahub/modules/api_resource'
require 'ahub/modules/deletable'
require 'ahub/list'
require 'ahub/version'
require 'ahub/action'
require 'ahub/user'
require 'ahub/question'
require 'ahub/answer'
require 'ahub/topic'
require 'ahub/space'
require 'ahub/group'

module Ahub
  #Load the .env file from the default location...
  Dotenv.load

  #or a location passed in.
  Dotenv.load ENV['AHUB_ENV_FILE'] if ENV['AHUB_ENV_FILE']

  DOMAIN = ENV['AHUB_DOMIAN'] || 'http://localhost:8888'
  ADMIN_USER = ENV['AHUB_ADMIN_USER'] || 'answerhub'
  ADMIN_PASS = ENV['AHUB_ADMIN_PASS'] || 'answerhub'
end
