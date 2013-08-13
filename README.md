# Capistrano Foreman

[![Code Climate](https://codeclimate.com/github/hyperoslo/capistrano-foreman.png)](https://codeclimate.com/github/hyperoslo/capistrano-foreman)

Capistrano tasks for foreman and upstart.

## Installation

    $ gem install capistrano-foreman

Add this to your `Capfile`:

```ruby
require 'capistrano/foreman'

# Default settings
set :foreman_sudo, ''   # Set to sudo if you need sudo privileges to export services, set to `rvmsudo` if you're using RVM
set :foreman_upstart_path, '/etc/init/'
set :foreman_options, {
  app: "sites/#{application}",
  log: "#{shared_path}/log",
  user: user,
}
```

See [exporting options](http://ddollar.github.io/foreman/#EXPORTING0) for an exhaustive list of foreman options.

## Usage

Export Procfile to upstart:

    $ cap foreman:export

Restart the application services:

    $ cap foreman:restart

## Rails usage

Server setup (assuming your capistrano user is `rails` with group `rails`)

```
# in /etc/sudoers
Cmnd_Alias UPSTART_SITES = /sbin/start sites/*,/sbin/stop sites/*,/sbin/restart sites/*,/sbin/status sites/*,/sbin/reload sites/*
rails  ALL=(root) NOPASSWD:UPSTART_SITES
```

Create the sites folder

```
# In this way rails user is allowed to export foreman configs without sudo
mkdir -p /etc/init/sites && chgrp rails /etc/init/sites && chmod 2775 /etc/init/sites
```

Capistrano config:

```ruby
# in config/deploy.rb 
require 'capistrano/foreman'
after 'deploy:restart', 'foreman:export'
after 'deploy:restart', 'foreman:restart'

```

Manage sites/app from shell as root or allowed sudoer:

```
(sudo) start sites/app
(sudo) stop sites/app
(sudo) restart sites/app
```

## Environment management

Foreman gem [handles environment variables](http://ddollar.github.io/foreman/#ENVIRONMENT) using .env files. It will load by default a file 
 named`.env` if such file exist. If you want more fine grained control on the environment of exported configuration you can use these two variables:

* `foreman_env_files`: (default `[]`) an explicit list of env files to load during export. It can be useful to load different env files in 
  different capistrano env. With multistage extension one can do `set foreman_env_files, ['common', rails_env]`. The argument is 
  an array of filenames *without* `.env` extension (it will be added automatically). If this list is not empty default `.env` file *won't*
  be loaded by foreman.
* `foreman_generate_rails_env`: (default `false`) if `true` a file with common Rails env variables (currently `RAILS_ENV` and `RACK_ENV`)
 is automatically generated and prepended to the above list. Notice that setting this option to `true` will disable loading of default `.env`
 file.

## Credits

Hyper made this. We're a digital communications agency with a passion for good code,
and if you're using this library we probably want to hire you.
