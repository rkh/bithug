source :gemcutter

def self.gem(name, version, options = {})
  options[:require] = false
  super
end

group :general do
  gem "thor",          "~> 0.13.0"
  gem "monkey-lib",    "~> 0.3.6"
  gem "backports",     ">= 1.13.2"
end

group :webserver do
  gem "swiftiply",     "~> 0.6.1.1"
  gem "thin",          "~> 1.2.5"
  gem "sinatra",       "~> 0.9.4"
  gem "async_sinatra", "~> 0.1.5"
  gem "big_band",      "~> 0.2.5"
end

group :test do
  gem "rack-test",     "~> 0.5.3"
  gem "rspec",         "~> 1.3.0"
end

group :tools do
  gem "rake",          ">= 0.8.7"
  gem "yard",          ">= 0.5.3"
  gem "yard-sinatra",  ">= 0.2.5"
end
