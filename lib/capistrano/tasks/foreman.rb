namespace :foreman do
  task :setup do
    invoke :'foreman:export'
    invoke :'foreman:start'
  end

  desc 'Export the Procfile'
  task :export do
    on roles fetch(:foreman_roles) do
      opts = {
        app: fetch(:application),
        log: File.join(shared_path, 'log'),
      }.merge fetch(:foreman_options, {})

      opts.merge!(host.properties.fetch(:foreman_options) || {})

      execute(:mkdir, "-p", opts[:log])

      within release_path do
        foreman_exec :foreman, 'export',
          fetch(:foreman_init_system),
          fetch(:foreman_export_path),
          opts.map { |opt, value| "--#{opt}=\"#{value}\"" }.join(' ')
      end

      if fetch(:foreman_init_system).to_sym == :systemd
        foreman_exec :systemctl, :'daemon-reload'
      end
    end
  end

  desc 'Start the application services'
  task :start do
    on roles fetch(:foreman_roles) do
      case fetch(:foreman_init_system).to_sym
      when :systemd
        foreman_exec :systemctl, :enable, fetch(:foreman_app_name_systemd)
        foreman_exec :systemctl, :start, fetch(:foreman_app_name_systemd)
      else
        foreman_exec :start, fetch(:foreman_app)
      end
    end
  end

  desc 'Stop the application services'
  task :stop do
    on roles fetch(:foreman_roles) do
      case fetch(:foreman_init_system).to_sym
      when :systemd
        foreman_exec :systemctl, :stop, fetch(:foreman_app_name_systemd)
        foreman_exec :systemctl, :disable, fetch(:foreman_app_name_systemd)
      else
        foreman_exec :stop, fetch(:foreman_app)
      end
    end
  end

  desc 'Restart the application services'
  task :restart do
    on roles fetch(:foreman_roles) do
      case fetch(:foreman_init_system).to_sym
      when :systemd
        foreman_exec :systemctl, :restart, fetch(:foreman_app_name_systemd)
      else
        foreman_exec :restart, fetch(:foreman_app)
      end
    end
  end

  def foreman_exec(*args)
    sudo_type = fetch(:foreman_use_sudo)
    case sudo_type.to_sym
    when :rbenv
      # this is required because 'rbenv sudo'
      # is not recognized by bundle_bins
      args.unshift(:bundle, :exec) if args[0].to_s == "foreman"
      execute(:rbenv, :sudo, *args)
    when :rvm
      execute(:rvmsudo, *args)
    when :chruby
      execute(:sudo, 'chruby-exec', fetch(:chruby_ruby), '--', *args)
    else
      sudo_type ? sudo(*args) : execute(*args)
    end
  end
end

namespace :load do
  task :defaults do
    set :bundle_bins, fetch(:bundle_bins, []).push(:foreman)
    set :foreman_use_sudo, false
    set :foreman_init_system, :upstart
    set :foreman_export_path, '/etc/init/sites'
    set :foreman_roles, :all
    set :foreman_app, -> { fetch(:application) }
    set :foreman_app_name_systemd, -> { "#{ fetch(:foreman_app) }.target" }

    if !fetch(:rvm_map_bins).nil?
      set :rvm_map_bins, fetch(:rvm_map_bins).push('foreman')
    end
  end
end
