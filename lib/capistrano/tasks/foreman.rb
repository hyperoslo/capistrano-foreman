namespace :foreman do
  task :setup do
    invoke :'foreman:export'
    invoke :'foreman:start'
  end

  desc 'Export the Procfile'
  task :export do
    on roles fetch(:foreman_roles) do
      within release_path do
        opts = {
          app: fetch(:application),
          log: File.join(shared_path, 'log'),
        }.merge fetch(:foreman_options, {})

        execute :foreman, 'export',
          fetch(:foreman_template),
          fetch(:foreman_export_path),
          opts.map { |opt, value| "--#{opt}='#{value}'" }.join(' ')
      end
    end
  end

  desc 'Start the application services'
  task :start do
    on roles fetch(:foreman_roles) do
      sudo :start, fetch(:foreman_app)
    end
  end

  desc 'Stop the application services'
  task :stop do
    on roles fetch(:foreman_roles) do
      sudo :stop, fetch(:foreman_app)
    end
  end

  desc 'Restart the application services'
  task :restart do
    on roles fetch(:foreman_roles) do
      sudo :restart, fetch(:foreman_app)
    end
  end
end

namespace :load do
  task :defaults do
    set :bundle_bins, fetch(:bundle_bins, []).push(%w(foreman))
    set :foreman_template, 'upstart'
    set :foreman_export_path, '/etc/init/sites'
    set :foreman_roles, :all
    set :foreman_app, -> { fetch(:application) }
  end
end
