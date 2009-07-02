#!/usr/bin/env ruby
require 'config/dependencies'
require 'sinatra'
require 'haml'


include Bithug

enable :sessions

helpers do
  def current_user
    session["user"] || User.new
  end
end

get "/" do
  haml :index, {}, :user => current_user
end

get "/update_user" do
  haml :user, {}, :user => current_user
end

post "/update_user" do
  options.authentication_agent.update params[:name], params
  redirect "/"
end

post "/add_user_key" do
  session["user"].add_key(params[:key])
  redirect "/"
end

post "/login" do
  if options.authentication_agent.authenticate params[:name], params[:password]
    session["user"] = User.get(params[:name])
  end
  redirect "/"
end

get "/logout" do
  session["user"] = nil
  redirect "/"
end

get "/:username" do
  haml :index, {}, :user => params[:user]
end

get "/create_repository" do
  haml :repository
end

post "/create_repository" do
  users = params[:userlist].gsub(" ", "").split(",")
  Repository.new.update(current_user.name, 
                        params[:name], users)
end
