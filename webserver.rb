#!/usr/bin/env ruby
require 'config/dependencies'
require 'sinatra'
require 'haml'

get "/" do
  haml :index, {}, :user => User.find
end