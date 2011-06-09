require 'minitest/unit'
require 'minitest/pride'
require 'minitest/autorun'

require File.expand_path('../lib/nesta/app', File.dirname(__FILE__))

module Nesta
  class App < Sinatra::Base
    set :environment, :test
    set :reload_templates, true
  end
end
