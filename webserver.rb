#!/usr/bin/env ruby
require 'config/dependencies'
require 'sinatra'
require 'haml'

include Bithug

get "/" do
  haml :index, {}, :user => User.all
end

get "/register" do
  haml :register
end

post "/register" do
  options.authentication_agent.
    register params[:name], params[:password]
  redirect "/"
end

post"/login" do
  res = options.authentication_agent.
    athenticate params[:name], params[:password]
  res.to_s
end
