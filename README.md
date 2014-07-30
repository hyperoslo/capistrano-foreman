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

## Example

A typical setup would look like the following:

Have a group-writeable directory under `/etc/init` for the group `deploy` (in this case I call it `sites`) to store the init scripts:

```bash
sudo mkdir /etc/init/sites
sudo chown :deploy /etc/init/sites
sudo chmod g+w /etc/init/sites
```

And the following configuration in `deploy.rb`:

```ruby
# Set the app with `sites/` prefix
set :foreman_app, -> { "sites/#{fetch(:application)}" }

# Set user to `deploy`, assuming this is your deploy user
set :foreman_user, 'deploy'

# Set root to `current_path` so exporting only have to be done once.
set :foreman_flags, "--root=#{current_path}"
```

Setup your init scripts by running `foreman:setup` after your first deploy.
From this moment on you only have to run `foreman:setup` when your `Procfile` has changed or when you alter the foreman deploy configuration.

Finally you have to instruct Capistrano to run `foreman:restart` after deploy:

```ruby
# Hook foreman restart after publishing
after :'deploy:publishing', :'foreman:restart'
```

## Notes

When using `rbenv`, `rvm`, `chruby` and/or `bundler` don't forget to add `foreman` to the bins list:

```ruby
fetch(:rbenv_map_bins, []).push 'foreman'
fetch(:rvm_map_bins, []).push 'foreman'
fetch(:chruby_map_bins, []).push 'foreman'
fetch(:bundle_bins, []).push 'foreman'
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request