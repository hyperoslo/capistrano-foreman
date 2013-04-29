Capistrano::Configuration.instance(:must_exist).load do |configuration|

  _cset(:foreman_sudo, 'sudo')
  _cset(:foreman_upstart_path, '/etc/init/sites')
  _cset(:foreman_upstart_prefix, '')
  _cset(:foreman_options, {})

  namespace :foreman do
    desc "Export the Procfile to Ubuntu's upstart scripts"
    task :export, roles: :app do
      run "if [[ -d #{foreman_upstart_path} ]]; then #{foreman_sudo} mkdir -p #{foreman_upstart_path}; fi"
      run "cd #{current_path} && #{foreman_sudo} bundle exec foreman export upstart #{foreman_upstart_path} #{foreman_options_cli}"
    end

    desc "Start the application services"
    task :start, roles: :app do
      sudo "service #{service_name} start"
    end

    desc "Stop the application services"
    task :stop, roles: :app do
      sudo "service #{service_name} stop"
    end

    desc "Restart the application services"
    task :restart, roles: :app do
      run "sudo service #{service_name} start || sudo service #{service_name}  restart"
    end
  end

  def service_name
    "#{foreman_upstart_prefix}#{application}"
  end

  def foreman_options_cli
    options = {
      :app => service_name,
      :log => "#{shared_path}/log",
      :user => user
    }
    options.merge!(foreman_options)
    opt = options.map {|opt, value| "--#{opt}=#{value}" }
    opt.join(' ')
  end
  
end
