Capistrano::Configuration.instance(:must_exist).load do |configuration|

  _cset :foreman_sudo, ""
  _cset :foreman_upstart_path, "/etc/init/"
  _cset :foreman_options, {}
  _cset :foreman_use_binstubs, false
  _cset :foreman_base_port, 5000
  _cset :foreman_procfile, 'Procfile'
  _cset :foreman_env_files, []
  _cset :foreman_generate_rails_env, false

  namespace :foreman do
    desc "Export the Procfile to Ubuntu's upstart scripts"
    task :export, roles: :app do
      generate_rails_env if generate_rails_env?
      cmd = foreman_use_binstubs ? 'bin/foreman' : 'bundle exec foreman'
      run "if [[ -d #{foreman_upstart_path} ]]; then #{foreman_sudo} mkdir -p #{foreman_upstart_path}; fi"
      run "cd #{current_path} && #{foreman_sudo} #{cmd} export -f #{foreman_procfile} -p #{foreman_base_port} upstart #{foreman_upstart_path} #{format(options)}"
    end
    
    desc "Start the application services"
    task :start, roles: :app do
      sudo "start #{service_name}"
    end

    desc "Stop the application services"
    task :stop, roles: :app do
      sudo "stop #{service_name}"
    end

    desc "Reload the application services"
    task :stop, roles: :app do
      sudo "reload #{service_name}"
    end

    desc "Restart the application services"
    task :restart, roles: :app do
      begin
        logger.info "Try to restart service #{service_name}"
        sudo "restart #{service_name}"
      rescue
        logger.info "Try to start service #{service_name} since it's not started yet"
        sudo "start #{service_name}"
      end
    end

    def options
      default_options.merge foreman_options
    end
    
    def service_name
      options[:app]
    end

    def format opts
      opts.map { |opt, value| "--#{opt}=#{value}" }.join " "
    end
    
    def default_options
      opts = {
        app: "sites/#{application}",
        log: "#{shared_path}/log",
        user: user
      }
      # Add environments option if any file is given using options
      opts[:env] = foreman_env_files.map { |env_file| "#{env_file}.env" }.join(',') unless foreman_env_files.empty?
      opts
    end
    
    # Write a rails.env file with common env entries for rails applications
    def generate_rails_env
      default_env = {
        'RAILS_ENV' => rails_env,
        'RACK_ENV' => rails_env,
      }
      # Write default environment to the server
      put default_env.map { |k,v| "#{k}=#{v}" }.join("\n"), "#{current_path}/rails.env"
      # Add generated file to file list used for export
      foreman_env_files.unshift('rails')
    end
    
    def generate_rails_env?
      foreman_generate_rails_env
    end
    
  end
  
end
