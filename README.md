# Capistrano Foreman

Capistrano tasks for foreman and upstart.

## Installation

    $ gem install capistrano-foreman

## Usage

Export Procfile to upstart:

  $ cap foreman:export

Restart the application services:

  $ cap foreman:restart
