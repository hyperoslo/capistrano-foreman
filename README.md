# Capistrano Foreman

[![Code Climate](https://codeclimate.com/github/hyperoslo/capistrano-foreman.png)](https://codeclimate.com/github/hyperoslo/capistrano-foreman)

Capistrano tasks for foreman and upstart.

## Installation

    $ gem install capistrano-foreman

Add this to your config/deploy.rb:

    require "foreman/capistrano"
    # Optional configurations for foreman CLI
    set :foreman_options, { 
      :env => '.env,.env.database',
      :concurrency => '3
    }
    # Optional configuration for RVM
    set :foreman_sudo, 'rvmsudo'

Remember to run ```cap foreman:export``` after changing the ENV variables.

## Usage

Export Procfile to upstart:

    $ cap foreman:export

Restart the application services:

    $ cap foreman:restart

## Credits

Hyper made this. We're a digital communications agency with a passion for good code,
and if you're using this library we probably want to hire you.
