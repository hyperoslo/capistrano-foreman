namespace :foreman do

  desc 'Export the Procfile'
  task :export do
    on roles foreman_roles.map(&:to_sym) do
      within release_path do
        use_sudo = foreman_use_sudo ? 'sudo' : ''
        command = foreman_use_binstubs ? 'bin/foreman' : 'bundle exec foreman'

        opts = {
          app: application,
          log: File.join(shared_path, 'log'),
          user: user
        }.merge(foreman_options)

        execute "#{use_sudo} #{command}",
          fetch(:foreman_template),
          fetch(:foreman_export_path),
          opts.map { |opt, value| "--#{opt}='#{value}'" }.join(' ')
      end
    end
  end

  desc 'Start the application services'
  task :start do
    on roles foreman_roles.map(&:to_sym) do
      use_sudo = foreman_use_sudo ? 'sudo' : ''
      app = foreman_options[:app] || application
      execute "#{use_sudo} service #{app} start"
    end
  end

  desc 'Stop the application services'
  task :stop do
    on roles foreman_roles do
      use_sudo = foreman_use_sudo ? 'sudo' : ''
      app = foreman_options[:app] || application
      execute "#{use_sudo} service #{app} stop"
    end
  end

  desc 'Restart the application services'
  task :restart do
    on roles foreman_roles.map(&:to_sym) do
      use_sudo = foreman_use_sudo ? 'sudo' : ''
      app = foreman_options[:app] || application
      execute "#{use_sudo} service #{app} restart"
    end
  end

end

namespace :load do
  task :defaults do
    set :foreman_use_sudo, true
    set :foreman_use_binstubs, false
    set :foreman_template, 'upstart'
    set :foreman_roles, %w{app}
    set :foreman_export_path, '/etc/init/sites'
  end
end
