Capistrano::Configuration.instance(:must_exist).load do |configuration|

  _cset :foreman_sudo, ""
  _cset :foreman_upstart_path, "/etc/init/"
  _cset :foreman_options, {}
  _cset :foreman_use_binstubs, false

  namespace :foreman do
    desc "Export the Procfile to Ubuntu's upstart scripts"
    task :export, roles: :app do
      cmd = foreman_use_binstubs ? 'bin/foreman' : 'bundle exec foreman'
      run "if [[ -d #{foreman_upstart_path} ]]; then #{foreman_sudo} mkdir -p #{foreman_upstart_path}; fi"
      run "cd #{current_path} && #{foreman_sudo} #{cmd} export upstart #{foreman_upstart_path} #{format(options)}"
    end

    desc "Start the application services"
    task :start, roles: :app do
      sudo "start #{service_name}"
    end

    desc "Stop the application services"
    task :stop, roles: :app do
      sudo "stop #{service_name}"
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
      {
        app: "sites/#{application}",
        log: "#{shared_path}/log",
        user: user
      }.merge foreman_options
    end
    
    def service_name
      options[:app]
    end

    def format opts
      opts.map { |opt, value| "--#{opt}=#{value}" }.join " "
    end
  end
  
end
