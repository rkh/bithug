#!/usr/bin/env ruby
require 'config/dependencies'
require 'sinatra'
require 'haml'

include Bithug

enable :sessions

get "/" do
  haml :index, {}, :user => User.get(session["username"])
end

get "/update_user" do
  haml :user, {}, :user => User.get(session["username"])
end

post "/update_user" do
  options.authentication_agent.update params[:name], params
  redirect "/"
end

post "/add_user_key" do
  User.get(session["username"].add_key(params[:key]))
  redirect "/"
end

post "/login" do
  if options.authentication_agent.authenticate params[:name], params[:password]
    session["username"] = params[:name]
  end
  redirect "/"
end

get "/logout" do
  session["username"] = nil
  redirect "/"
end

get "/:username" do
  haml :index, {}, :user => User.get(params[:username])
end

get "/create_repository" do
  haml :repository
end

post "/create_repository" do
  users = params[:userlist].gsub(" ", "").split(",")
  Repository.new.update(session["username"], 
                        params[:name], users)
end
