Capistrano::Configuration.instance(:must_exist).load do |configuration|

  _cset(:foreman_sudo, 'sudo')
  _cset(:foreman_upstart_path, '/etc/init/sites')
  _cset(:foreman_options, {})

  namespace :foreman do
    desc "Export the Procfile to Ubuntu's upstart scripts"
    task :export, roles: :app do
      run "if [[ -d #{foreman_upstart_path} ]]; then #{foreman_sudo} mkdir -p #{foreman_upstart_path}; fi"
      run "cd #{current_path} && #{foreman_sudo} bundle exec foreman export upstart #{foreman_upstart_path} #{opts(foreman_opts)}"
    end

    desc "Start the application services"
    task :start, roles: :app do
      sudo "service #{foreman_opts[:app]} start"
    end

    desc "Stop the application services"
    task :stop, roles: :app do
      sudo "service #{foreman_opts[:app]} stop"
    end

    desc "Restart the application services"
    task :restart, roles: :app do
      run "sudo service #{foreman_opts[:app]} start || sudo service #{foreman_opts[:app]}  restart"
    end
  end

  def foreman_opts
    options = {
      :app => application,
      :log => "#{shared_path}/log",
      :user => user
    }
    options.merge(foreman_options)
  end

  def opts(options)
    opts = options.map {|opt, value| "--#{opt}=#{value}" }
    opts.join(' ')
  end
  
end
