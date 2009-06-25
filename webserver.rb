#!/usr/bin/env ruby
require 'config/dependencies'
require 'sinatra'
require 'haml'

include Bithug

get "/" do
  haml :index, {}, :user => User.all
end