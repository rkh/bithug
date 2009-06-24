#!/usr/bin/env ruby
require 'config/dependencies'
require 'sinatra'
require 'haml'

get("/") { "Hello World!" }