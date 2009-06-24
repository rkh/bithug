#!/usr/bin/env ruby
require 'sinatra'
require 'haml'

# Load this after loading sinatra, so we can
# ask sinatra for the current environment
require 'config/dependencies'

get("/") { "Hello World!" }