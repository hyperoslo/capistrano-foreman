Capistrano::Configuration.instance(:must_exist).load do |configuration|

  _cset :foreman_sudo, "sudo"
  _cset :foreman_upstart_path, "/etc/init/sites"
  _cset :foreman_options, {}

  namespace :foreman do
    desc "Export the Procfile to Ubuntu's upstart scripts"
    task :export, roles: :app do
      run "if [[ -d #{foreman_upstart_path} ]]; then #{foreman_sudo} mkdir -p #{foreman_upstart_path}; fi"
      run "cd #{current_path} && #{foreman_sudo} bundle exec foreman export upstart #{foreman_upstart_path} #{options(foreman_options)}"
    end

    desc "Start the application services"
    task :start, roles: :app do
      sudo "service #{foreman_options[:app]} start"
    end

    desc "Stop the application services"
    task :stop, roles: :app do
      sudo "service #{foreman_options[:app]} stop"
    end

    desc "Restart the application services"
    task :restart, roles: :app do
      run "sudo service #{foreman_options[:app]} start || sudo service #{foreman_options[:app]}  restart"
    end
  end

  def foreman_options
    {
      app: application,
      log: "#{shared_path}/log",
      user: user
    }.merge foreman_options
  end

  def options options
    options.map { |opt, value| "--#{opt}=#{value}" }.join " "
  end
  
end
