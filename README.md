# Capistrano::foreman

Foreman support for Capistrano 3

## Installation

```ruby
gem 'capistrano', '~> 3.1'
gem 'capistrano-foreman', github: 'koenpunt/capistrano-foreman'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install capistrano-foreman

## Usage

Require in `Capfile`:

```ruby
require 'capistrano/foreman'
```

Export Procfile to process management format (defaults to upstart) and restart the application services:

    $ cap foreman:setup
    $ cap foreman:start

Configurable options, shown here with defaults:

```ruby
set :foreman_roles, :all
set :foreman_export_format, 'upstart'
set :foreman_export_path, '/etc/init'
set :foreman_flags, "--root=#{current_path}" # optional, default is empty string
set :foreman_target_path, release_path
set :foreman_app, -> { fetch(:application) }
set :foreman_concurrency, 'web=2,worker=1' # optional, default is not set
set :foreman_log, -> { shared_path.join('log') }
set :foreman_port, 3000 # optional, default is not set
set :foreman_user, 'www-data' # optional, default is not set
```

See [exporting options](http://ddollar.github.io/foreman/#EXPORTING) for an exhaustive list of foreman options.

### Tasks

This gem provides the following Capistrano tasks:

* `foreman:setup` exports the Procfile and starts application services
* `foreman:export` exports the Procfile to process management format
* `foreman:restart` restarts the application services
* `foreman:start` starts the application services
* `foreman:stop` stops the application services

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request