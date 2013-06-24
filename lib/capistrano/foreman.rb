Capistrano::Configuration.instance(:must_exist).load do |configuration|

  _cset :foreman_sudo, "sudo"
  _cset :foreman_upstart_path, "/etc/init/sites"
  _cset :foreman_options, {}
  _cset :foreman_use_binstubs, false

  namespace :foreman do
    desc "Export the Procfile to Ubuntu's upstart scripts"
    task :export do
      find_servers_for_task(current_task).each do |host|
        export_options = format({:concurrency => concurrency_from_roles(host)}.merge(options))

        cmd = foreman_use_binstubs ? 'bin/foreman' : 'bundle exec foreman'
        run "if [[ -d #{foreman_upstart_path} ]]; then #{foreman_sudo} mkdir -p #{foreman_upstart_path}; fi", :hosts => host
        run "cd #{current_path} && #{foreman_sudo} #{cmd} export upstart #{foreman_upstart_path} #{export_options}", :hosts => host
      end
    end

    desc "Start the application services"
    task :start do
      sudo "service #{options[:app]} start"
    end

    desc "Stop the application services"
    task :stop do
      sudo "service #{options[:app]} stop"
    end

    desc "Restart the application services"
    task :restart do
      run "sudo service #{options[:app]} start || sudo service #{options[:app]}  restart"
    end

    def options
      {
        app: application,
        log: "#{shared_path}/log",
        user: user
      }.merge foreman_options
    end

    def concurrency_from_roles(host)
      roles.map {|role_name, role| "#{role_name}=1" if role.include?(host) }.compact.join(',')
    end

    def format opts
      opts.map { |opt, value| "--#{opt}=#{value}" }.join " "
    end
  end
end
