Capistrano::Configuration.instance(:must_exist).load do |configuration|

  _cset(:foreman_sudo, 'sudo')

  namespace :foreman do
    desc "Export the Procfile to Ubuntu's upstart scripts"
    task :export, roles: :app do
      run "cd #{current_path} && #{foreman_sudo} bundle exec foreman export upstart /etc/init -a foreman-#{application} -u #{user} -l #{shared_path}/log #{concurrency}"
    end

    desc "Start the application services"
    task :start, roles: :app do
      sudo "service foreman-#{application} start"
    end

    desc "Stop the application services"
    task :stop, roles: :app do
      sudo "service foreman-#{application} stop"
    end

    desc "Restart the application services"
    task :restart, roles: :app do
      run "sudo service foreman-#{application} start || sudo service foreman-#{application} restart"
    end
  end

  def concurrency
    foreman_settings = ENV.select { |key, value| key.to_s.match(/FOREMAN_.+/) } 
    processes = foreman_settings.map { |process,n| "#{process.downcase}=#{n}" }.join(',')
    processes.gsub!('foreman_','')
    processes.empty? ? nil : "-c #{processes}"
  end
  
end
