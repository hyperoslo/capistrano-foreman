namespace :foreman do
  desc <<-DESC
        Setup foreman configuration

        Configurable options are:

          set :foreman_roles, :all
          set :foreman_upstart_path, '/etc/init'
          set :foreman_flags, ''
          set :foreman_target_path, release_path
          set :foreman_app, -> { fetch(:application) }
          set :foreman_concurrency, 'web=2,worker=1' # default is not set
          set :foreman_log, -> { shared_path.join('log') }
          set :foreman_port, 3000 # default is not set
          set :foreman_user, 'www-data' # default is not set
    DESC

  task :setup do
    invoke :'foreman:export'
    invoke :'foreman:start'
  end

  desc "Export the Procfile to Ubuntu's upstart scripts"
  task :export do
    on roles fetch(:foreman_roles) do
      execute :mkdir, "-p", fetch(:foreman_upstart_path) unless test "[ -d #{fetch(:foreman_upstart_path)} ]"
      within fetch(:foreman_target_path, release_path) do

        options = {
          app: fetch(:foreman_app),
          log: fetch(:foreman_log)
        }
        options[:concurrency] = fetch(:foreman_concurrency) if fetch(:foreman_concurrency)
        options[:port] = fetch(:foreman_port) if fetch(:foreman_port)
        options[:user] = fetch(:foreman_user) if fetch(:foreman_user)

        execute :foreman, 'export', 'upstart', fetch(:foreman_upstart_path),
          options.map{ |k, v| "--#{k}='#{v}'" }, fetch(:foreman_flags)
      end
    end
  end

  desc "Start the application services"
  task :start do
    on roles fetch(:foreman_roles) do
      sudo :start, fetch(:foreman_app)
    end
  end

  desc "Stop the application services"
  task :stop do
    on roles fetch(:foreman_roles) do
      sudo :stop, fetch(:foreman_app)
    end
  end

  desc "Restart the application services"
  task :restart do
    on roles fetch(:foreman_roles) do
      sudo :restart, fetch(:foreman_app)
    end
  end

end

namespace :load do
  task :defaults do
    set :foreman_roles, :all
    set :foreman_upstart_path, '/etc/init'
    set :foreman_flags, ''
    set :foreman_app, -> { fetch(:application) }
    set :foreman_log, -> { shared_path.join('log') }
  end
end
