# Capistrano Foreman

[![Code Climate](https://img.shields.io/codeclimate/github/hyperoslo/capistrano-foreman.svg?style=flat)](https://codeclimate.com/github/hyperoslo/capistrano-foreman)

Capistrano tasks for foreman and upstart/systemd.

## Installation

    $ gem install capistrano-foreman

Add this to your `Capfile`:

```ruby
require 'capistrano/foreman'

# Default settings
set :foreman_use_sudo, false # Set to :rbenv for rbenv sudo, :rvm for rvmsudo or true for normal sudo
set :foreman_roles, :all
set :foreman_init_system, 'upstart'
set :foreman_export_path, ->{ File.join(Dir.home, '.init') }
set :foreman_app, -> { fetch(:application) }
set :foreman_app_name_systemd, -> { "#{ fetch(:foreman_app) }.target" }
set :foreman_options, ->{ {
  app: application,
  log: File.join(shared_path, 'log')
} }
```

See [exporting options](http://ddollar.github.io/foreman/#EXPORTING) for an exhaustive list of foreman options.

### Use it with capistrano-bundler
You don't have to configure anything, it's already compatible with capistrano-bundler!

## Usage

Export Procfile to upstart/systemd:

    $ bundle exec cap production foreman:export

Restart the application services:

    $ bundle exec cap production foreman:restart

## Credits

Hyper made this. We're a digital communications agency with a passion for good code,
and if you're using this library we probably want to hire you.
