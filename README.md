# Capistrano Foreman

[![Code Climate](https://codeclimate.com/github/hyperoslo/capistrano-foreman.png)](https://codeclimate.com/github/hyperoslo/capistrano-foreman)

Capistrano tasks for foreman and upstart.

## Installation

    $ gem install capistrano-foreman

Add this to your config/deploy.rb:

```ruby
require 'foreman/capistrano'

# Defaults settings
set :foreman_sudo, 'sudo' # Set to `rvmsudo` if using RVM
set :foreman_upstart_path, '/etc/init/sites' # Set /etc/init/ if you do not have a sites folder
set :foreman_upstart_prefix, '' # Set to ex. `foreman-` or `staging-` if you want to prefix jobs names

# Optionnal configurations for foreman :
set :foreman_options, {
  :env => '.env,.env.database',
  :concurrency => '3
}
```

Remember to run ```cap foreman:export``` after changing the ENV variables.

## Usage

Export Procfile to upstart:

    $ cap foreman:export

Restart the application services:

    $ cap foreman:restart

## Credits

Hyper made this. We're a digital communications agency with a passion for good code,
and if you're using this library we probably want to hire you.
