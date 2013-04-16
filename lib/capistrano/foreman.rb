Capistrano::Configuration.instance(:must_exist).load do |configuration|

  namespace :foreman do
    desc "Export the Procfile to Ubuntu's upstart scripts"
    task :export, roles: :app do
      run "cd #{current_path} && sudo bundle exec foreman export upstart /etc/init -a sites/#{application} -u #{user} -l #{shared_path}/log #{concurrency}"
    end

    desc "Start the application services"
    task :start, roles: :app do
      sudo "service sites/#{application} start"
    end

    desc "Stop the application services"
    task :stop, roles: :app do
      sudo "service sites/#{application} stop"
    end

    desc "Restart the application services"
    task :restart, roles: :app do
      run "sudo service sites/#{application} start || sudo service sites/#{application} restart"
    end
  end


  def concurrency
    processes = ""
  
    IO.foreach("Procfile") do |line|
      line.match /\A([\w]+):.+CONCURRENCY=([\d]+)/       # $1 == processname, $2 == concurrency
      processes += "#{$1}=#{$2},"    if $1 and $2
    end
  
    processes.empty? ? nil : "-c #{processes.chomp!(',')}"
  end
  
  
end
