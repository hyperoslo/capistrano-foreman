Capistrano::Configuration.instance(:must_exist).load do |configuration|

  _cset :foreman_sudo, "sudo"
  _cset :foreman_upstart_path, "/etc/init/sites"
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
      sudo "restart #{service_name}"
    end

    def options
      {
        app: application,
        log: "#{shared_path}/log",
        user: user
      }.merge foreman_options
    end
    
    def service_name
      # /etc/init/app.conf => start/stop/reload app
      # /etc/init/sites/app.conf => start/stop/reload sites/app
      # /other/path/ => ???
      if foreman_upstart_path.start_with? "/etc/init" 
        foreman_upstart_path =~ %r{^/etc/init/?$} ? application : "#{foreman_upstart_path.gsub(%{/etc/init/}, '')}/#{application}"
      else
        # ??? when upstart jobs are exported outside /etc/init what is the behavior?
        application
      end
    end

    def format opts
      opts.map { |opt, value| "--#{opt}=#{value}" }.join " "
    end
  end
  
end
