# Capistrano Foreman

[![Join the chat at https://gitter.im/hyperoslo/capistrano-foreman](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/hyperoslo/capistrano-foreman?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

[![Code Climate](https://img.shields.io/codeclimate/github/hyperoslo/capistrano-foreman.svg?style=flat)](https://codeclimate.com/github/hyperoslo/capistrano-foreman)

Capistrano tasks for foreman and upstart.

## Installation

    $ gem install capistrano-foreman

Add this to your `Capfile`:

```ruby
require 'capistrano/foreman'

# Default settings
set :foreman_use_sudo, false # Set to :rbenv for rbenv sudo, :rvm for rvmsudo or true for normal sudo
set :foreman_roles, :all
set :foreman_template, 'upstart'
set :foreman_export_path, ->{ File.join(Dir.home, '.init') }
set :foreman_options, ->{ {
  app: application,
  log: File.join(shared_path, 'log')
} }
```

See [exporting options](http://ddollar.github.io/foreman/#EXPORTING) for an exhaustive list of foreman options.

## Usage

Export Procfile to upstart:

    $ bundle exec cap production foreman:export

Restart the application services:

    $ bundle exec cap production foreman:restart

## Credits

Hyper made this. We're a digital communications agency with a passion for good code,
and if you're using this library we probably want to hire you.
